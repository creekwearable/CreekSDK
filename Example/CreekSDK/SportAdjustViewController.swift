//
//  SportAdjustViewController.swift
//  CreekSDK_Example
//

import UIKit
import CreekSDK

final class SportAdjustViewController: CreekBaseViewController {
   private let tableView = UITableView(frame: .zero, style: .insetGrouped)
   private let activityIndicator = UIActivityIndicatorView(style: .large)
   private let unsupportedLabel = UILabel()
   private let addButton = UIButton(type: .system)
   private let deleteButton = UIButton(type: .system)
   private let buttonStack = UIStackView()

   private var supportedTypes: [sport_type] = []
   private var configuredTypes: [sport_type] = []
   private var selectedDeleteTypes = Set<sport_type>()

   private var availableTypes: [sport_type] {
      supportedTypes.filter { !configuredTypes.contains($0) }
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Dynamic Sport Adjust"
      setupUI()
      checkFeatureSupport()
   }

   private func setupUI() {
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.dataSource = self
      tableView.delegate = self

      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.hidesWhenStopped = true

      unsupportedLabel.translatesAutoresizingMaskIntoConstraints = false
      unsupportedLabel.text = "Dynamic sport adjustment is not supported by this device."
      unsupportedLabel.textColor = .secondaryLabel
      unsupportedLabel.font = .systemFont(ofSize: 17, weight: .medium)
      unsupportedLabel.textAlignment = .center
      unsupportedLabel.numberOfLines = 0
      unsupportedLabel.isHidden = true

      configureButton(addButton, title: "Add Sports", action: #selector(showAddSportPicker))
      configureButton(deleteButton, title: "Delete Selected", action: #selector(deleteSelected))
      deleteButton.setTitleColor(.systemRed, for: .normal)

      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.addArrangedSubview(addButton)
      buttonStack.addArrangedSubview(deleteButton)
      buttonStack.axis = .horizontal
      buttonStack.spacing = 12
      buttonStack.distribution = .fillEqually

      view.addSubview(tableView)
      view.addSubview(buttonStack)
      view.addSubview(unsupportedLabel)
      view.addSubview(activityIndicator)
      navigationItem.rightBarButtonItem = UIBarButtonItem(
         barButtonSystemItem: .refresh,
         target: self,
         action: #selector(refreshData)
      )

      NSLayoutConstraint.activate([
         tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -8),

         buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
         buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
         buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
         buttonStack.heightAnchor.constraint(equalToConstant: 48),

         unsupportedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
         unsupportedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
         unsupportedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

         activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
      showContent(false)
   }

   private func configureButton(_ button: UIButton, title: String, action: Selector) {
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
      button.backgroundColor = .secondarySystemBackground
      button.layer.cornerRadius = 8
      button.addTarget(self, action: action, for: .touchUpInside)
   }

   @objc private func refreshData() {
      checkFeatureSupport()
   }

   private func checkFeatureSupport() {
      setLoading(true)
      showContent(false)
      unsupportedLabel.isHidden = true

      CreekInterFace.instance.getTable { [weak self] table in
         DispatchQueue.main.async {
            guard let self = self else { return }
            let isSupported = table.hasSportAdjust && table.sportAdjust.isSupport
            if isSupported {
               self.loadSportLists()
            } else {
               self.setLoading(false)
               self.unsupportedLabel.isHidden = false
            }
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage(title: "Feature Check Failed", message: "\(code): \(message)")
         }
      }
   }

   /// Load the supported list first, then the device's current dynamic list.
   private func loadSportLists() {
      setLoading(true)
      selectedDeleteTypes.removeAll()

      CreekInterFace.instance.getSportType { [weak self] supportReply in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.supportedTypes = supportReply.supportType
            CreekInterFace.instance.getSportAdjust { [weak self] adjustReply in
               DispatchQueue.main.async {
                  guard let self = self else { return }
                  self.configuredTypes = adjustReply.items
                  self.setLoading(false)
                  self.showContent(true)
                  self.tableView.reloadData()
                  self.updateButtons()
               }
            } failure: { [weak self] code, message in
               DispatchQueue.main.async {
                  self?.setLoading(false)
                  self?.showMessage(title: "Current Sports Query Failed", message: "\(code): \(message)")
               }
            }
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage(title: "Supported Sports Query Failed", message: "\(code): \(message)")
         }
      }
   }

   @objc private func showAddSportPicker() {
      let candidates = availableTypes
      guard !candidates.isEmpty else {
         showMessage(title: "No Sports Available", message: "All sports supported by this device have already been added.")
         return
      }

      let picker = SportTypePickerViewController(
         types: candidates,
         nameProvider: { [weak self] in self?.sportName($0) ?? String(describing: $0) }
      ) { [weak self] selectedTypes in
         self?.performOperation(.insert, items: selectedTypes)
      }
      present(UINavigationController(rootViewController: picker), animated: true)
   }

   @objc private func deleteSelected() {
      let items = configuredTypes.filter(selectedDeleteTypes.contains)
      guard !items.isEmpty else { return }

      let alert = UIAlertController(
         title: "Delete Sports",
         message: "Delete the \(items.count) selected sport(s)?",
         preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
         self?.performOperation(.delete, items: items)
      })
      present(alert, animated: true)
   }

   private func performOperation(_ type: operate_II_type, items: [sport_type]) {
      var operate = protocol_sport_adjust_operate()
      operate.operate = type
      operate.items = items
      setLoading(true)

      CreekInterFace.instance.setSportAdjust(model: operate) { [weak self] in
         // Refresh from the device after every successful mutation.
         DispatchQueue.main.async {
            self?.loadSportLists()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage(title: "Operation Failed", message: "\(code): \(message)")
         }
      }
   }

   private func showContent(_ visible: Bool) {
      tableView.isHidden = !visible
      buttonStack.isHidden = !visible
   }

   private func setLoading(_ loading: Bool) {
      DispatchQueue.main.async {
         if loading {
            self.activityIndicator.startAnimating()
         } else {
            self.activityIndicator.stopAnimating()
         }
         self.tableView.isUserInteractionEnabled = !loading
         self.navigationItem.rightBarButtonItem?.isEnabled = !loading
         self.updateButtons(enabled: !loading)
      }
   }

   private func updateButtons(enabled: Bool = true) {
      addButton.isEnabled = enabled && !availableTypes.isEmpty
      deleteButton.isEnabled = enabled && !selectedDeleteTypes.isEmpty
   }

   private func showMessage(title: String, message: String) {
      guard presentedViewController == nil else { return }
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
   }

   private func sportName(_ type: sport_type) -> String {
      "\(String(describing: type)) (\(type.rawValue))"
   }
}

extension SportAdjustViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      configuredTypes.count
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      "Current Sports (select one or more to delete)"
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let identifier = "SportAdjustCell"
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
         ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      let type = configuredTypes[indexPath.row]
      let selected = selectedDeleteTypes.contains(type)
      cell.textLabel?.text = sportName(type)
      cell.detailTextLabel?.text = "Position \(indexPath.row + 1)"
      cell.accessoryType = selected ? .checkmark : .none
      cell.textLabel?.textColor = selected ? .systemRed : .label
      cell.selectionStyle = .none
      return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let type = configuredTypes[indexPath.row]
      if !selectedDeleteTypes.insert(type).inserted {
         selectedDeleteTypes.remove(type)
      }
      tableView.reloadRows(at: [indexPath], with: .none)
      updateButtons()
   }
}

private final class SportTypePickerViewController: UITableViewController {
   private let types: [sport_type]
   private let nameProvider: (sport_type) -> String
   private let onConfirm: ([sport_type]) -> Void
   private var selectedTypes = Set<sport_type>()

   init(
      types: [sport_type],
      nameProvider: @escaping (sport_type) -> String,
      onConfirm: @escaping ([sport_type]) -> Void
   ) {
      self.types = types
      self.nameProvider = nameProvider
      self.onConfirm = onConfirm
      super.init(style: .insetGrouped)
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Select Sports"
      navigationItem.leftBarButtonItem = UIBarButtonItem(
         barButtonSystemItem: .cancel,
         target: self,
         action: #selector(cancel)
      )
      navigationItem.rightBarButtonItem = UIBarButtonItem(
         title: "Add (0)",
         style: .done,
         target: self,
         action: #selector(confirm)
      )
      navigationItem.rightBarButtonItem?.isEnabled = false
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      types.count
   }

   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      "Select one or more sports"
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let identifier = "AddSportCell"
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
         ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
      let type = types[indexPath.row]
      cell.textLabel?.text = nameProvider(type)
      cell.accessoryType = selectedTypes.contains(type) ? .checkmark : .none
      cell.selectionStyle = .none
      return cell
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let type = types[indexPath.row]
      if !selectedTypes.insert(type).inserted {
         selectedTypes.remove(type)
      }
      tableView.reloadRows(at: [indexPath], with: .none)
      navigationItem.rightBarButtonItem?.title = "Add (\(selectedTypes.count))"
      navigationItem.rightBarButtonItem?.isEnabled = !selectedTypes.isEmpty
   }

   @objc private func cancel() {
      dismiss(animated: true)
   }

   @objc private func confirm() {
      let items = types.filter(selectedTypes.contains)
      guard !items.isEmpty else { return }
      dismiss(animated: true) { [onConfirm] in
         onConfirm(items)
      }
   }
}
