//
//  HealthMeasureViewController.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/10/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

import UIKit
import SnapKit

class HealthMeasureViewController: UIViewController {
    
    // MARK: - UI 元素
    private let typePicker = UIPickerView()
    private let startButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let statusLabel = UILabel()
    
    // MARK: - 数据
    private let healthTypes: [ring_health_type] = [
        .ringHeartRate,
        .ringStress,
        .ringSpo2,
        .ringHrv,
        .ringRespiratoryRate,
        .af
    ]
    
    private var selectedType: ring_health_type = .ringHeartRate
    private var measuringTask: Task<Void, Never>?
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "健康测量"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - UI 初始化
    private func setupUI() {
        // Picker
        typePicker.dataSource = self
        typePicker.delegate = self
        view.addSubview(typePicker)
        typePicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        // Start Button
        startButton.setTitle("开始测量", for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 12
        startButton.addTarget(self, action: #selector(startMeasureTapped), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(typePicker.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        
        // Stop Button
        stopButton.setTitle("停止测量", for: .normal)
        stopButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        stopButton.backgroundColor = .systemRed
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.cornerRadius = 12
        stopButton.addTarget(self, action: #selector(stopMeasureTapped), for: .touchUpInside)
        view.addSubview(stopButton)
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(15)
            make.left.right.height.equalTo(startButton)
        }
        
        // Status Label
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .center
        statusLabel.text = "状态：未开始"
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stopButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Result Label
        resultLabel.font = .systemFont(ofSize: 22, weight: .bold)
        resultLabel.textColor = .label
        resultLabel.textAlignment = .center
        resultLabel.text = "--"
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - 操作事件
    @objc private func startMeasureTapped() {
        resultLabel.text = "--"
        statusLabel.text = "状态：测量中..."
        
        // 取消旧任务
        measuringTask?.cancel()
        
        measuringTask = Task {
            do {
                let value = try await HealthMeasureManager.shared.measureHealth(
                    selectedType: selectedType,
                    measureType: .healthMeasureStart
                )
                await MainActor.run {
                    statusLabel.text = "状态：测量完成 ✅"
                    resultLabel.text = "结果：\(value)"
                }
            } catch {
                await MainActor.run {
                    statusLabel.text = "状态：\(error.localizedDescription)"
                    resultLabel.text = "--"
                }
            }
        }
    }
    
    @objc private func stopMeasureTapped() {
        measuringTask?.cancel()
        Task {
            do {
                _ = try await HealthMeasureManager.shared.measureHealth(
                    selectedType: selectedType,
                    measureType: .healthMeasureStop
                )
                await MainActor.run {
                    statusLabel.text = "状态：已停止测量 ⛔️"
                }
            } catch {
                await MainActor.run {
                    statusLabel.text = "停止失败：\(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - UIPickerView 数据源 & 代理
extension HealthMeasureViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        healthTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch healthTypes[row] {
        case .ringHeartRate: return "心率"
        case .ringStress: return "压力"
        case .ringSpo2: return "血氧"
        case .ringHrv: return "HRV"
        case .ringRespiratoryRate: return "呼吸率"
        case .af: return "房颤检测"
        default: return "未知"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = healthTypes[row]
    }
}


class HealthMeasureManager {
    
    static let shared = HealthMeasureManager()
    private var lastMeasureTime: Date?
    
    /// 点击测量，返回最终测量值或错误
    func measureHealth(
        selectedType: ring_health_type,
        measureType: health_measure_type,
        timeout: TimeInterval = 60   // ⏱ 超时 60 秒
    ) async throws -> Int {
        
        var measuredValue = 0
        var endBool = false
        let startTime = Date()
        
        // 1️⃣ 发送测量指令
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            var operateModel = protocol_ring_click_measure_operate()
            operateModel.healthType = selectedType
            operateModel.measureType = measureType
            
            CreekInterFace.instance.setClickHealthMeasure(model: operateModel) { model in
                switch model.measureStatus {
                case .healthStatusNoWear:
                    continuation.resume(throwing: NSError(domain: "HealthMeasure", code: 1, userInfo: [NSLocalizedDescriptionKey: "未佩戴"]))
                case .healthStatusFail:
                    continuation.resume(throwing: NSError(domain: "HealthMeasure", code: 2, userInfo: [NSLocalizedDescriptionKey: "测量失败"]))
                default:
                    continuation.resume(returning: ())
                }
            } failure: { code, message in
                continuation.resume(throwing: NSError(domain: "HealthMeasure", code: code, userInfo: [NSLocalizedDescriptionKey: message]))
            }
        }
        
        // 停止命令直接返回
        if measureType == .healthMeasureStop {
            return measuredValue
        }
        
        // 2️⃣ 轮询获取结果
        while !endBool {
            // 超时检查
            if Date().timeIntervalSince(startTime) > timeout {
                // 超时停止测量
                Task {
                    var stopModel = protocol_ring_click_measure_operate()
                    stopModel.healthType = selectedType
                    stopModel.measureType = .healthMeasureStop
                    CreekInterFace.instance.setClickHealthMeasure(model: stopModel) { _ in
                        print("⏰ 超时，已自动发送停止测量指令")
                    } failure: { code, message in
                        print("❌ 停止测量失败: \(code), \(message)")
                    }
                }
                throw NSError(domain: "HealthMeasure", code: 3, userInfo: [NSLocalizedDescriptionKey: "测量超时"])
            }
            
            // 控制最小 1 秒间隔
            if let last = lastMeasureTime {
                let diff = Date().timeIntervalSince(last)
                if diff < 1 {
                    try await Task.sleep(nanoseconds: UInt64((1 - diff) * 1_000_000_000))
                }
            }
            lastMeasureTime = Date()
            
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                CreekInterFace.instance.getClickHealthMeasure(type: selectedType) { model in
                    // 停止命令时退出
                    if model.measureType == .healthMeasureStop {
                        endBool = true
                        continuation.resume(returning: ())
                        return
                    }
                    
                    switch model.measureStatus {
                    case .healthStatusResult:
                        measuredValue = Int(model.value)
                        endBool = true
                        
                        // 自动发送停止测量指令
                        Task {
                            var stopModel = protocol_ring_click_measure_operate()
                            stopModel.healthType = selectedType
                            stopModel.measureType = .healthMeasureStop
                            CreekInterFace.instance.setClickHealthMeasure(model: stopModel) { _ in
                                print("✅ 已发送停止测量指令")
                            } failure: { code, message in
                                print("❌ 停止测量失败: \(code), \(message)")
                            }
                        }
                        continuation.resume(returning: ())
                        
                    case .healthStatusNoWear:
                        endBool = true
                        continuation.resume(throwing: NSError(domain: "HealthMeasure", code: 1, userInfo: [NSLocalizedDescriptionKey: "未佩戴"]))
                        
                    case .healthStatusFail:
                        endBool = true
                        continuation.resume(throwing: NSError(domain: "HealthMeasure", code: 2, userInfo: [NSLocalizedDescriptionKey: "测量失败"]))
                        
                    default:
                        continuation.resume(returning: ())
                    }
                } failure: { code, message in
                    continuation.resume(throwing: NSError(domain: "HealthMeasure", code: code, userInfo: [NSLocalizedDescriptionKey: message]))
                }
            }
        }
        
        return measuredValue
    }
}
