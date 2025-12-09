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
       
       CreekInterFace.instance.startMeasure(type: selectedType,measureDuration: 30,timeout: 60) { [weak self] model in
          self?.resultLabel.text =  "结果：\(model.value) 脉率:\(model.pulseRateValue)"
       } success: {[weak self] in
          self?.statusLabel.text = "状态：测量完成 ✅"
       } failure: {[weak self] model in
          self?.statusLabel.text = model.message
       } abnormal: {
          print("有异动")
       }

    }
    
    @objc private func stopMeasureTapped() {
       statusLabel.text = "状态：已停止测量 ⛔️"
       CreekInterFace.instance.stopMeasure(type: selectedType)
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

