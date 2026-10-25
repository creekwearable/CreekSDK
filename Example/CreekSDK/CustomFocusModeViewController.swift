import UIKit
import ContactsUI
import CreekSDK

final class CustomFocusModeViewController: CreekBaseViewController {
   private let tableView = UITableView(frame: .zero, style: .insetGrouped)
   private let indicator = UIActivityIndicatorView(style: .large)
   private var items: [protocol_custom_focus_mode_item] = []
   private var defaultFocusModeID: UInt64 = 0

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Custom Focus Mode"
      navigationItem.rightBarButtonItems = [
         UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMode)),
         UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshModes))
      ]
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.dataSource = self
      tableView.delegate = self
      indicator.translatesAutoresizingMaskIntoConstraints = false
      indicator.hidesWhenStopped = true
      view.addSubview(tableView)
      view.addSubview(indicator)
      NSLayoutConstraint.activate([
         tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
      refreshModes()
   }

   @objc private func refreshModes() {
      indicator.startAnimating()
      CreekInterFace.instance.getCustomFocusMode(operate: protocol_custom_focus_mode_operate()) { [weak self] reply in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.defaultFocusModeID = reply.defaultFocusModeID
            self.items = reply.items
            self.indicator.stopAnimating()
            self.tableView.reloadData()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.indicator.stopAnimating()
            self?.showMessage(title: "Query Failed", message: "\(code): \(message)")
         }
      }
   }

   @objc private func addMode() {
      showEditor(item: nil)
   }

   private func showEditor(item: protocol_custom_focus_mode_item?) {
      let editor = CustomFocusModeEditorViewController(
         item: item,
         isDefault: item?.id == defaultFocusModeID
      )
      editor.onChanged = { [weak self] savedItem, deletedID, setAsDefault in
         guard let self = self else { return }
         if setAsDefault, let savedItem = savedItem {
            self.defaultFocusModeID = savedItem.id
         }
         if let deletedID = deletedID {
            self.items.removeAll { $0.id == deletedID }
         } else if let savedItem = savedItem {
            if let index = self.items.firstIndex(where: { $0.id == savedItem.id }) {
               self.items[index] = savedItem
            } else {
               self.items.append(savedItem)
            }
         }
         self.tableView.reloadData()
      }
      navigationController?.pushViewController(editor, animated: true)
   }

   private func showMessage(title: String, message: String) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
   }
}

extension CustomFocusModeViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      items.isEmpty ? "No custom focus mode returned by the device" : "Device custom focus modes"
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FocusCell")
         ?? UITableViewCell(style: .subtitle, reuseIdentifier: "FocusCell")
      let item = items[indexPath.row]
      let name = String(data: item.name, encoding: .utf8) ?? "Focus Mode \(item.id)"
      cell.textLabel?.text = item.id == defaultFocusModeID ? "\(name)  (Default)" : name
      cell.detailTextLabel?.text = "ID \(item.id) · \(item.slots.count) time slot(s) · priority \(item.priority)"
      cell.accessoryType = .disclosureIndicator
      return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      showEditor(item: items[indexPath.row])
   }
}

private struct FocusTimeSlotDraft {
   var enabled = true
   var startHour = 9
   var startMinute = 0
   var endHour = 18
   var endMinute = 0
   var repeatDays = [true, true, true, true, true, false, false]

   init() {}

   init(_ value: custom_focus_time_slot) {
      enabled = value.switchFlag
      startHour = Int(value.startHour)
      startMinute = Int(value.startMinute)
      endHour = Int(value.endHour)
      endMinute = Int(value.endMinute)
      if value.repeatDays.count >= 7 {
         repeatDays = Array(value.repeatDays.prefix(7))
      } else {
         switch value.repeat {
         case 1: repeatDays = Array(repeating: true, count: 7)
         case 2: repeatDays = [true, true, true, true, true, false, false]
         case 3: repeatDays = [false, false, false, false, false, true, true]
         default: repeatDays = Array(repeating: false, count: 7)
         }
      }
   }

   var protocolValue: custom_focus_time_slot {
      var value = custom_focus_time_slot()
      value.switchFlag = enabled
      value.startHour = UInt32(startHour)
      value.startMinute = UInt32(startMinute)
      value.endHour = UInt32(endHour)
      value.endMinute = UInt32(endMinute)
      value.repeatDays = repeatDays
      if repeatDays.allSatisfy({ $0 }) {
         value.repeat = 1
      } else if repeatDays == [true, true, true, true, true, false, false] {
         value.repeat = 2
      } else if repeatDays == [false, false, false, false, false, true, true] {
         value.repeat = 3
      } else if repeatDays.contains(true) {
         value.repeat = 4
      } else {
         value.repeat = 0
      }
      return value
   }

   var summary: String {
      String(format: "%02d:%02d-%02d:%02d", startHour, startMinute, endHour, endMinute)
   }
}

private final class CustomFocusModeEditorViewController: UIViewController, CNContactPickerDelegate, UIGestureRecognizerDelegate {
   var onChanged: ((protocol_custom_focus_mode_item?, UInt64?, Bool) -> Void)?

   private let sourceItem: protocol_custom_focus_mode_item?
   private let scrollView = UIScrollView()
   private let stackView = UIStackView()
   private let idLabel = UILabel()
   private let nameField = UITextField()
   private let defaultSwitch = UISwitch()
   private let priorityControl = UISegmentedControl(items: ["80", "50", "20"])
   private let slotButton = UIButton(type: .system)
   private let brightnessLabel = UILabel()
   private let brightnessSlider = UISlider()
   private let timeoutButton = UIButton(type: .system)
   private let conflictButton = UIButton(type: .system)
   private let contactScopeButton = UIButton(type: .system)
   private let contactButton = UIButton(type: .system)
   private let contactSummaryLabel = UILabel()
   private let appScopeButton = UIButton(type: .system)
   private let appButton = UIButton(type: .system)
   private let appSummaryLabel = UILabel()
   private let silentSwitch = UISwitch()
   private let aodSwitch = UISwitch()
   private let wifiSwitch = UISwitch()
   private let btCallingSwitch = UISwitch()
   private let powerSavingSwitch = UISwitch()
   private let raiseToWakeSwitch = UISwitch()
   private let saveButton = UIButton(type: .system)
   private let deleteButton = UIButton(type: .system)
   private let activityIndicator = UIActivityIndicatorView(style: .medium)

   private var focusModeID: UInt64
   private var slots: [FocusTimeSlotDraft]
   private var contacts: [custom_focus_contact]
   private var allowedApps: [message_remind_type]
   private var contactScope: custom_focus_contact_scope_type
   private var appScope: custom_focus_app_scope_type
   private var conflictPolicy: custom_focus_conflict_policy_type
   private var timeout: UInt32

   init(item: protocol_custom_focus_mode_item?, isDefault: Bool) {
      sourceItem = item
      focusModeID = item?.id ?? Self.makeID()
      slots = item?.slots.map(FocusTimeSlotDraft.init) ?? [FocusTimeSlotDraft()]
      contacts = item?.contacts ?? []
      allowedApps = item?.allowedApps.filter { $0 != .null } ?? [.sms, .email]
      contactScope = item?.contactScope ?? .contactScopeEveryone
      appScope = item?.appScope ?? .appScopeAll
      conflictPolicy = item?.conflictPolicy ?? .conflictPolicyDiscard
      let candidateTimeout = item?.screenTimeoutSec ?? 15
      timeout = Self.timeoutOptions.contains(candidateTimeout) ? candidateTimeout : 15
      super.init(nibName: nil, bundle: nil)
      defaultSwitch.isOn = isDefault
   }

   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = sourceItem == nil ? "Add Custom Focus Mode" : "Edit Custom Focus Mode"
      view.backgroundColor = .systemGroupedBackground
      setupUI()
      setupKeyboardDismissal()
      fillValues()
      refreshMenus()
      refreshSummaries()
   }

   private func setupKeyboardDismissal() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tap.cancelsTouchesInView = false
      tap.delegate = self
      view.addGestureRecognizer(tap)
      scrollView.keyboardDismissMode = .interactive
   }

   @objc private func dismissKeyboard() {
      view.endEditing(true)
   }

   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      !(touch.view is UIControl)
   }

   private func setupUI() {
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.axis = .vertical
      stackView.spacing = 12
      view.addSubview(scrollView)
      scrollView.addSubview(stackView)
      NSLayoutConstraint.activate([
         scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
         stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
         stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
         stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28)
      ])

      idLabel.numberOfLines = 0
      nameField.borderStyle = .roundedRect
      nameField.placeholder = "Mode name (max 64 UTF-8 bytes)"
      priorityControl.selectedSegmentIndex = 0
      brightnessSlider.minimumValue = 1
      brightnessSlider.maximumValue = 100
      brightnessSlider.addTarget(self, action: #selector(brightnessChanged), for: .valueChanged)
      contactButton.addTarget(self, action: #selector(selectContacts), for: .touchUpInside)
      appButton.addTarget(self, action: #selector(selectApps), for: .touchUpInside)
      slotButton.addTarget(self, action: #selector(editSlots), for: .touchUpInside)
      timeoutButton.addTarget(self, action: #selector(selectTimeout), for: .touchUpInside)
      conflictButton.addTarget(self, action: #selector(selectConflictPolicy), for: .touchUpInside)
      contactScopeButton.addTarget(self, action: #selector(selectContactScope), for: .touchUpInside)
      appScopeButton.addTarget(self, action: #selector(selectAppScope), for: .touchUpInside)
      saveButton.setTitle("Save", for: .normal)
      saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
      saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
      deleteButton.setTitle("Delete This Focus Mode", for: .normal)
      deleteButton.setTitleColor(.systemRed, for: .normal)
      deleteButton.addTarget(self, action: #selector(confirmDelete), for: .touchUpInside)
      contactSummaryLabel.numberOfLines = 0
      contactSummaryLabel.textColor = .secondaryLabel
      appSummaryLabel.numberOfLines = 0
      appSummaryLabel.textColor = .secondaryLabel

      addSection("Basic Information")
      stackView.addArrangedSubview(idLabel)
      stackView.addArrangedSubview(nameField)
      stackView.addArrangedSubview(labeledRow("Priority", priorityControl))
      stackView.addArrangedSubview(noteLabel("Mode type: FOUS_CUSTOM. Icon and color are fixed to 0 by the current protocol."))
      stackView.addArrangedSubview(labeledRow("Set as default when saving", defaultSwitch))
      addSection("Time Slots")
      stackView.addArrangedSubview(slotButton)
      addSection("Display")
      stackView.addArrangedSubview(brightnessLabel)
      stackView.addArrangedSubview(brightnessSlider)
      stackView.addArrangedSubview(timeoutButton)
      stackView.addArrangedSubview(conflictButton)
      addSection("Contacts")
      stackView.addArrangedSubview(contactScopeButton)
      contactButton.setTitle("Select from System Contacts", for: .normal)
      stackView.addArrangedSubview(contactButton)
      stackView.addArrangedSubview(contactSummaryLabel)
      addSection("App Messages")
      stackView.addArrangedSubview(appScopeButton)
      appButton.setTitle("Select Allowed Message Types", for: .normal)
      stackView.addArrangedSubview(appButton)
      stackView.addArrangedSubview(appSummaryLabel)
      addSection("Mode Switches")
      stackView.addArrangedSubview(labeledRow("Silent mode", silentSwitch))
      stackView.addArrangedSubview(labeledRow("Always-on display (AOD)", aodSwitch))
      stackView.addArrangedSubview(labeledRow("Wi-Fi", wifiSwitch))
      stackView.addArrangedSubview(labeledRow("Bluetooth calling", btCallingSwitch))
      stackView.addArrangedSubview(labeledRow("Power saving", powerSavingSwitch))
      stackView.addArrangedSubview(labeledRow("Raise to wake", raiseToWakeSwitch))
      stackView.addArrangedSubview(saveButton)
      if sourceItem != nil { stackView.addArrangedSubview(deleteButton) }
      stackView.addArrangedSubview(activityIndicator)
   }

   private func fillValues() {
      idLabel.text = "64-bit mode ID\n\(focusModeID)"
      nameField.text = sourceItem.flatMap { String(data: $0.name, encoding: .utf8) } ?? "Work"
      let priority = sourceItem?.priority ?? 80
      priorityControl.selectedSegmentIndex = Self.priorityOptions.firstIndex(of: priority) ?? 0
      brightnessSlider.value = Float(max(1, min(sourceItem?.brightnessPercent ?? 60, 100)))
      let flags = sourceItem?.hasModeFlags == true ? sourceItem?.modeFlags : nil
      silentSwitch.isOn = flags?.silentModeFlag ?? false
      aodSwitch.isOn = flags?.aodFlag ?? false
      wifiSwitch.isOn = flags?.wifiFlag ?? true
      btCallingSwitch.isOn = flags?.btCallingFlag ?? true
      powerSavingSwitch.isOn = flags?.powerSavingFlag ?? false
      raiseToWakeSwitch.isOn = flags?.raiseToWakeFlag ?? true
      brightnessChanged()
   }

   private func refreshMenus() {
      timeoutButton.setTitle("Screen timeout: \(timeout) seconds", for: .normal)
      conflictButton.setTitle("Conflict policy: \(Self.enumName(conflictPolicy))", for: .normal)
      contactScopeButton.setTitle("Contact scope: \(Self.enumName(contactScope))", for: .normal)
      appScopeButton.setTitle("App scope: \(Self.enumName(appScope))", for: .normal)
   }

   @objc private func selectTimeout() {
      showChoices(title: "Screen timeout", values: Self.timeoutOptions.map { value in
         ("\(value) seconds", { [weak self] in self?.timeout = value })
      })
   }

   @objc private func selectConflictPolicy() {
      showChoices(title: "Conflict policy", values: custom_focus_conflict_policy_type.allCases.map { value in
         (Self.enumName(value), { [weak self] in self?.conflictPolicy = value })
      })
   }

   @objc private func selectContactScope() {
      showChoices(title: "Contact scope", values: custom_focus_contact_scope_type.allCases.map { value in
         (Self.enumName(value), { [weak self] in self?.contactScope = value })
      })
   }

   @objc private func selectAppScope() {
      showChoices(title: "App scope", values: custom_focus_app_scope_type.allCases.map { value in
         (Self.enumName(value), { [weak self] in self?.appScope = value })
      })
   }

   private func showChoices(title: String, values: [(String, () -> Void)]) {
      let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
      values.forEach { title, action in
         alert.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
            action()
            self?.refreshMenus()
            self?.refreshSummaries()
         })
      }
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      if let popover = alert.popoverPresentationController {
         popover.sourceView = view
         popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
      }
      present(alert, animated: true)
   }

   private func refreshSummaries() {
      slotButton.setTitle("Manage Time Slots (\(slots.count))", for: .normal)
      let customContacts = contactScope == .contactScopeCustom
      contactButton.isHidden = !customContacts
      contactSummaryLabel.isHidden = !customContacts
      contactSummaryLabel.text = contacts.isEmpty ? "No contacts selected" : contacts.map {
         let name = String(data: $0.contactName, encoding: .utf8) ?? ""
         let phone = String(data: $0.phoneNumber, encoding: .utf8) ?? ""
         return "\(name)  \(phone)"
      }.joined(separator: "\n")
      let customApps = appScope == .focusAppScopeCustom
      appButton.isHidden = !customApps
      appSummaryLabel.isHidden = !customApps
      appSummaryLabel.text = allowedApps.isEmpty ? "No message type selected" : allowedApps.map(Self.enumName).joined(separator: ", ")
   }

   @objc private func brightnessChanged() {
      brightnessLabel.text = "Brightness: \(Int(brightnessSlider.value.rounded()))%"
   }

   @objc private func editSlots() {
      let controller = FocusTimeSlotsViewController(slots: slots)
      controller.onChanged = { [weak self] slots in
         self?.slots = slots
         self?.refreshSummaries()
      }
      navigationController?.pushViewController(controller, animated: true)
   }

   @objc private func selectContacts() {
      let picker = CNContactPickerViewController()
      picker.delegate = self
      present(picker, animated: true)
   }

   func contactPicker(_ picker: CNContactPickerViewController, didSelect selectedContacts: [CNContact]) {
      var values: [custom_focus_contact] = []
      for contact in selectedContacts {
         guard let phone = contact.phoneNumbers.first?.value.stringValue, !phone.isEmpty else { continue }
         var value = custom_focus_contact()
         value.contactName = Self.utf8Data(CNContactFormatter.string(from: contact, style: .fullName) ?? phone, maxBytes: 64)
         value.phoneNumber = Self.utf8Data(phone, maxBytes: 32)
         values.append(value)
      }
      contacts = values
      refreshSummaries()
   }

   @objc private func selectApps() {
      let picker = FocusAppPickerViewController(selected: Set(allowedApps.map(\.rawValue)))
      picker.onDone = { [weak self] selected in
         self?.allowedApps = selected.compactMap(message_remind_type.init(rawValue:)).filter { $0 != .null }
         self?.refreshSummaries()
      }
      present(UINavigationController(rootViewController: picker), animated: true)
   }

   @objc private func save() {
      let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      guard !name.isEmpty else { showMessage("Please enter a mode name"); return }
      guard name.data(using: .utf8)?.count ?? 0 <= 64 else { showMessage("The mode name cannot exceed 64 UTF-8 bytes"); return }
      guard contactScope != .contactScopeCustom || !contacts.isEmpty else { showMessage("Select at least one contact for the custom contact scope"); return }
      guard appScope != .focusAppScopeCustom || !allowedApps.isEmpty else { showMessage("Select at least one message type for the custom app scope"); return }

      var item = protocol_custom_focus_mode_item()
      item.id = focusModeID
      item.name = Data(name.utf8)
      item.icon = 0
      item.color = 0
      item.slots = slots.map(\.protocolValue)
      item.contactScope = contactScope
      item.contacts = contactScope == .contactScopeCustom ? contacts : []
      item.appScope = appScope
      item.allowedApps = appScope == .focusAppScopeCustom ? allowedApps : []
      item.brightnessPercent = UInt32(brightnessSlider.value.rounded())
      item.screenTimeoutSec = timeout
      item.conflictPolicy = conflictPolicy
      item.modeType = .fousCustom
      item.priority = Self.priorityOptions[priorityControl.selectedSegmentIndex]
      var flags = custom_focus_mode_flags()
      flags.silentModeFlag = silentSwitch.isOn
      flags.aodFlag = aodSwitch.isOn
      flags.wifiFlag = wifiSwitch.isOn
      flags.btCallingFlag = btCallingSwitch.isOn
      flags.powerSavingFlag = powerSavingSwitch.isOn
      flags.raiseToWakeFlag = raiseToWakeSwitch.isOn
      item.modeFlags = flags

      setLoading(true)
      var operate = protocol_custom_focus_mode_operate()
      operate.items = [item]
      if defaultSwitch.isOn {
         operate.defaultFocusModeID = item.id
      }
      CreekInterFace.instance.upsertCustomFocusMode(operate: operate) { [weak self] in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.setLoading(false)
            self.onChanged?(item, nil, self.defaultSwitch.isOn)
            self.navigationController?.popViewController(animated: true)
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage("Save failed (\(code)): \(message)")
         }
      }
   }

   @objc private func confirmDelete() {
      let alert = UIAlertController(title: "Delete Focus Mode", message: "This operation cannot be undone.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in self?.deleteMode() })
      present(alert, animated: true)
   }

   private func deleteMode() {
      setLoading(true)
      CreekInterFace.instance.deleteCustomFocusMode(focusModeIds: [focusModeID]) { [weak self] in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.setLoading(false)
            self.onChanged?(nil, self.focusModeID, false)
            self.navigationController?.popViewController(animated: true)
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage("Delete failed (\(code)): \(message)")
         }
      }
   }

   private func setLoading(_ loading: Bool) {
      if loading { activityIndicator.startAnimating() } else { activityIndicator.stopAnimating() }
      view.isUserInteractionEnabled = !loading
   }

   private func addSection(_ title: String) {
      let label = UILabel()
      label.text = title
      label.font = .systemFont(ofSize: 18, weight: .bold)
      stackView.addArrangedSubview(label)
   }

   private func labeledRow(_ title: String, _ control: UIView) -> UIStackView {
      let label = UILabel()
      label.text = title
      let row = UIStackView(arrangedSubviews: [label, control])
      row.axis = .horizontal
      row.alignment = .center
      row.spacing = 12
      return row
   }

   private func noteLabel(_ text: String) -> UILabel {
      let label = UILabel()
      label.text = text
      label.font = .systemFont(ofSize: 13)
      label.textColor = .secondaryLabel
      label.numberOfLines = 0
      return label
   }

   private func showMessage(_ message: String) {
      let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
   }

   private static let timeoutOptions: [UInt32] = [7, 10, 15, 25, 30, 45, 60]
   private static let priorityOptions: [UInt32] = [80, 50, 20]

   private static func makeID() -> UInt64 {
      (UInt64(Date().timeIntervalSince1970 * 1000) << 22) | UInt64.random(in: 0..<(1 << 22))
   }

   private static func enumName<T>(_ value: T) -> String { String(describing: value) }

   private static func utf8Data(_ string: String, maxBytes: Int) -> Data {
      var data = Data()
      for character in string {
         let bytes = Data(String(character).utf8)
         if data.count + bytes.count > maxBytes { break }
         data.append(bytes)
      }
      return data
   }
}

private final class FocusTimeSlotsViewController: UITableViewController {
   var onChanged: (([FocusTimeSlotDraft]) -> Void)?
   private var slots: [FocusTimeSlotDraft]

   init(slots: [FocusTimeSlotDraft]) {
      self.slots = slots
      super.init(style: .insetGrouped)
   }
   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Time Slots"
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSlot))
   }

   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      if isMovingFromParent { onChanged?(slots) }
   }

   @objc private func addSlot() { openEditor(slot: FocusTimeSlotDraft(), index: nil) }

   private func openEditor(slot: FocusTimeSlotDraft, index: Int?) {
      let editor = FocusTimeSlotEditorViewController(slot: slot)
      editor.onSave = { [weak self] value in
         guard let self = self else { return }
         if let index = index { self.slots[index] = value } else { self.slots.append(value) }
         self.tableView.reloadData()
      }
      navigationController?.pushViewController(editor, animated: true)
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { slots.count }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Slot") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Slot")
      let slot = slots[indexPath.row]
      cell.textLabel?.text = "Time Slot \(indexPath.row + 1)"
      cell.detailTextLabel?.text = "\(slot.summary) · \(slot.enabled ? "Enabled" : "Disabled")"
      cell.accessoryType = .disclosureIndicator
      return cell
   }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      openEditor(slot: slots[indexPath.row], index: indexPath.row)
   }
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete { slots.remove(at: indexPath.row); tableView.deleteRows(at: [indexPath], with: .automatic) }
   }
}

private final class FocusTimeSlotEditorViewController: UIViewController {
   var onSave: ((FocusTimeSlotDraft) -> Void)?
   private var slot: FocusTimeSlotDraft
   private let enabledSwitch = UISwitch()
   private let startPicker = UIDatePicker()
   private let endPicker = UIDatePicker()
   private var dayButtons: [UIButton] = []

   init(slot: FocusTimeSlotDraft) { self.slot = slot; super.init(nibName: nil, bundle: nil) }
   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Edit Time Slot"
      view.backgroundColor = .systemGroupedBackground
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = 16
      view.addSubview(stack)
      NSLayoutConstraint.activate([
         stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
         stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
      ])
      enabledSwitch.isOn = slot.enabled
      stack.addArrangedSubview(row("Enabled", enabledSwitch))
      configure(startPicker, hour: slot.startHour, minute: slot.startMinute)
      configure(endPicker, hour: slot.endHour, minute: slot.endMinute)
      stack.addArrangedSubview(row("Start", startPicker))
      stack.addArrangedSubview(row("End", endPicker))
      let days = UIStackView()
      days.axis = .horizontal
      days.distribution = .fillEqually
      for (index, title) in ["M", "T", "W", "T", "F", "S", "S"].enumerated() {
         let button = UIButton(type: .system)
         button.tag = index
         button.setTitle(title, for: .normal)
         button.addTarget(self, action: #selector(toggleDay(_:)), for: .touchUpInside)
         dayButtons.append(button)
         days.addArrangedSubview(button)
      }
      stack.addArrangedSubview(days)
      refreshDays()
   }

   private func row(_ title: String, _ control: UIView) -> UIStackView {
      let label = UILabel(); label.text = title
      let row = UIStackView(arrangedSubviews: [label, control]); row.axis = .horizontal; row.alignment = .center
      return row
   }
   private func configure(_ picker: UIDatePicker, hour: Int, minute: Int) {
      picker.datePickerMode = .time
      picker.date = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? Date()
   }
   @objc private func toggleDay(_ sender: UIButton) { slot.repeatDays[sender.tag].toggle(); refreshDays() }
   private func refreshDays() {
      for button in dayButtons { button.backgroundColor = slot.repeatDays[button.tag] ? .systemBlue : .clear; button.setTitleColor(slot.repeatDays[button.tag] ? .white : .systemBlue, for: .normal) }
   }
   @objc private func save() {
      let start = Calendar.current.dateComponents([.hour, .minute], from: startPicker.date)
      let end = Calendar.current.dateComponents([.hour, .minute], from: endPicker.date)
      slot.enabled = enabledSwitch.isOn
      slot.startHour = start.hour ?? 0; slot.startMinute = start.minute ?? 0
      slot.endHour = end.hour ?? 0; slot.endMinute = end.minute ?? 0
      onSave?(slot)
      navigationController?.popViewController(animated: true)
   }
}

private final class FocusAppPickerViewController: UITableViewController, UISearchResultsUpdating {
   var onDone: (([Int]) -> Void)?
   private var selected: Set<Int>
   private var query = ""
   private var options: [message_remind_type] {
      message_remind_type.allCases.filter { $0 != .null && (query.isEmpty || String(describing: $0).localizedCaseInsensitiveContains(query)) }
   }
   init(selected: Set<Int>) { self.selected = selected; super.init(style: .insetGrouped) }
   required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Allowed Message Types"
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
      let search = UISearchController(searchResultsController: nil); search.searchResultsUpdater = self; navigationItem.searchController = search
   }
   @objc private func cancel() { dismiss(animated: true) }
   @objc private func done() { let values = selected.sorted(); dismiss(animated: true) { self.onDone?(values) } }
   func updateSearchResults(for searchController: UISearchController) { query = searchController.searchBar.text ?? ""; tableView.reloadData() }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { options.count }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "App") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "App")
      let item = options[indexPath.row]; cell.textLabel?.text = String(describing: item); cell.detailTextLabel?.text = "value: \(item.rawValue)"; cell.accessoryType = selected.contains(item.rawValue) ? .checkmark : .none
      return cell
   }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let value = options[indexPath.row].rawValue; if selected.contains(value) { selected.remove(value) } else { selected.insert(value) }; tableView.reloadRows(at: [indexPath], with: .none)
   }
}
