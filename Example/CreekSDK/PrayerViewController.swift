import UIKit
import CreekSDK

/// Small native test page. Location is fixed; no search or location permissions.
final class PrayerViewController: CreekBaseViewController {
   private let location = PrayerLocation.coordinates(
      latitude: 33.58831, longitude: -7.61138, countryCode: "MA", name: "Casablanca", altitude: 27)
   private let output = UITextView()
   private var buttons: [UIButton] = []
   private var sendButton: UIButton!
   private var snapshot: CreekPrayerResult?
   private var busy = false
   private var requestToken = UUID()

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Prayer demo"
      view.backgroundColor = .systemBackground
      let label = UILabel()
      label.numberOfLines = 0
      label.text = "Casablanca, MA\n33.58831, -7.61138 · altitude 27 m\n固定坐标，读取与下发分开"
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = 8
      stack.addArrangedSubview(label)
      addButton("getPrayerConfiguration · 获取配置", action: #selector(loadConfiguration), to: stack)
      addButton("configurePrayer · 保存自动模式", action: #selector(saveAutomatic), to: stack)
      addButton("configurePrayer · Morocco / Hanafi", action: #selector(saveManual), to: stack)
      addButton("getPrayerTimes · 读取七天", action: #selector(readTimes), to: stack)
      sendButton = addButton("setPrayer · 下发已读数据", action: #selector(sendTimes), to: stack)
      output.isEditable = false
      output.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
      output.textColor = .label
      stack.addArrangedSubview(output)
      view.addSubview(stack)
      stack.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
         stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
         stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
         output.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
      ])
      updateButtons()
      loadConfiguration()
   }

   @discardableResult
   private func addButton(_ title: String, action: Selector, to stack: UIStackView) -> UIButton {
      let button = UIButton(type: .system)
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15)
      button.addTarget(self, action: action, for: .touchUpInside)
      buttons.append(button)
      stack.addArrangedSubview(button)
      return button
   }
   private func updateButtons() {
      buttons.forEach { $0.isEnabled = !busy }
      sendButton?.isEnabled = !busy && snapshot != nil
   }
   private func begin(_ message: String) -> UUID {
      requestToken = UUID()
      let token = requestToken
      busy = true
      output.text = message
      updateButtons()
      // Legacy device callbacks may not arrive after disconnecting.
      DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
         guard let self = self, self.busy, self.requestToken == token else { return }
         self.finish(token, "操作超时，请检查连接后重试")
      }
      return token
   }
   private func finish(_ token: UUID, _ message: String) {
      guard token == requestToken, busy else { return }
      busy = false
      output.text = message
      updateButtons()
   }
   private func describe(_ configuration: CreekPrayerConfiguration) -> String {
      "automatic: \(configuration.automatic)\nmethod: \(configuration.method.rawValue)\nasrRule: \(configuration.asrRule.rawValue)\n配置重启后保留。自动模式的实际规则以读取结果为准。"
   }

   @objc private func loadConfiguration() {
      guard !busy else { return }
      let token = begin("读取已保存配置…")
      CreekInterFace.instance.getPrayerConfiguration { [weak self] config in
         guard let self = self else { return }
         self.finish(token, self.describe(config))
      } failure: { [weak self] _, message in self?.finish(token, message) }
   }
   @objc private func saveAutomatic() { save(CreekPrayerConfiguration()) }
   @objc private func saveManual() {
      save(CreekPrayerConfiguration(automatic: false, method: .morocco, asrRule: .hanafi))
   }
   private func save(_ config: CreekPrayerConfiguration) {
      guard !busy else { return }
      let token = begin("保存配置…")
      CreekInterFace.instance.configurePrayer(config) { [weak self] in
         guard let self = self, self.busy, self.requestToken == token else { return }
         self.snapshot = nil
         self.finish(token, "保存成功\n" + self.describe(config))
      } failure: { [weak self] _, message in self?.finish(token, message) }
   }
   @objc private func readTimes() {
      guard !busy else { return }
      snapshot = nil
      let token = begin("读取 Casablanca 七天时间…")
      CreekInterFace.instance.getPrayerTimes(location: location) { [weak self] result in
         guard let self = self, self.busy, self.requestToken == token else { return }
         self.snapshot = result
         let config = result.configuration
         var lines = ["\(config.location.name) · \(config.location.timezoneId)",
                      "\(config.method.rawValue) / \(config.asrRule.rawValue)",
                      "日期 晨礼 日出 晌礼 晡礼 昏礼 宵礼"]
         for day in result.days {
            lines.append("\(day.date)\n\(day.fajr) \(day.sunrise) \(day.dhuhr) \(day.asr) \(day.maghrib) \(day.isha)\n\(day.source.rawValue) · UTC offset \(day.utcOffsetMinutes) min")
         }
         self.finish(token, lines.joined(separator: "\n\n"))
      } failure: { [weak self] _, message in self?.finish(token, message) }
   }
   private var connected: Bool {
      [.connect, .sync, .syncComplete].contains(CreekInterFace.instance.connectStatus)
   }
   @objc private func sendTimes() {
      guard !busy, let result = snapshot else { return }
      guard connected else { output.text = "请先连接手表，已读数据保留。"; return }
      let token = begin("读取设备功能表…")
      // Capability checks belong to the Demo, not the SDK setPrayer command.
      CreekInterFace.instance.getTable { [weak self] table in
         DispatchQueue.main.async {
            guard let self = self, self.busy, self.requestToken == token else { return }
            guard self.connected else { self.finish(token, "请先连接手表"); return }
            guard table.prayerOnline.isSupport else {
               self.finish(token, "该设备不支持祈祷功能")
               return
            }
            self.output.text = "下发七天数据…"
            CreekInterFace.instance.setPrayer(model: result.operate) { [weak self] in
               DispatchQueue.main.async { self?.finish(token, "七天祈祷时间已下发手表") }
            } failure: { [weak self] _, message in
               DispatchQueue.main.async { self?.finish(token, "下发失败：\(message)") }
            }
         }
      } failure: { [weak self] _, message in
         DispatchQueue.main.async { self?.finish(token, "读取设备功能表失败：\(message)") }
      }
   }
}
