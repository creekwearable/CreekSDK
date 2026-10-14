//
//  SportAdjustViewController.swift
//  CreekSDK_Example
//

import UIKit
import CreekSDK

/// Demonstrates the current sport-adjust protocol: the device returns the full
/// ordered list and App writes the full list back with each item's visibility.
final class SportAdjustViewController: CreekBaseViewController {
   private let tableView = UITableView(frame: .zero, style: .insetGrouped)
   private let activityIndicator = UIActivityIndicatorView(style: .large)
   private let unsupportedLabel = UILabel()
   private let saveButton = UIButton(type: .system)
   private let reloadButton = UIButton(type: .system)
   private let buttonStack = UIStackView()

   private var items: [sport_adjust_item] = []
   private var savedItems: [sport_adjust_item] = []

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
      tableView.isEditing = true
      tableView.allowsSelectionDuringEditing = false

      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.hidesWhenStopped = true

      unsupportedLabel.translatesAutoresizingMaskIntoConstraints = false
      unsupportedLabel.text = "Dynamic sport adjustment is not supported by this device."
      unsupportedLabel.textColor = .secondaryLabel
      unsupportedLabel.font = .systemFont(ofSize: 17, weight: .medium)
      unsupportedLabel.textAlignment = .center
      unsupportedLabel.numberOfLines = 0
      unsupportedLabel.isHidden = true

      configureButton(saveButton, title: "Save All", action: #selector(saveAll))
      configureButton(reloadButton, title: "Reload", action: #selector(refreshData))

      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.addArrangedSubview(saveButton)
      buttonStack.addArrangedSubview(reloadButton)
      buttonStack.axis = .horizontal
      buttonStack.spacing = 12
      buttonStack.distribution = .fillEqually

      view.addSubview(tableView)
      view.addSubview(buttonStack)
      view.addSubview(unsupportedLabel)
      view.addSubview(activityIndicator)

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
            if table.hasSportAdjust && table.sportAdjust.isSupport {
               self.loadSportAdjust()
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

   private func loadSportAdjust() {
      setLoading(true)
      CreekInterFace.instance.getSportAdjust { [weak self] reply in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.items = reply.items
            self.savedItems = reply.items
            self.tableView.reloadData()
            self.showContent(true)
            self.setLoading(false)
            self.updateButtons()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage(title: "Query Failed", message: "\(code): \(message)")
         }
      }
   }

   @objc private func saveAll() {
      guard hasChanges else { return }
      var operate = protocol_sport_adjust_operate()
      operate.operate = .set
      operate.items = items
      setLoading(true)
      CreekInterFace.instance.setSportAdjust(model: operate) { [weak self] in
         DispatchQueue.main.async { self?.loadSportAdjust() }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.setLoading(false)
            self?.showMessage(title: "Save Failed", message: "\(code): \(message)")
         }
      }
   }

   @objc private func visibilityChanged(_ sender: UISwitch) {
      guard items.indices.contains(sender.tag) else { return }
      items[sender.tag].isShow = sender.isOn
      tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
      updateButtons()
   }

   private var hasChanges: Bool {
      guard items.count == savedItems.count else { return true }
      return zip(items, savedItems).contains { pair in
         pair.0.type != pair.1.type || pair.0.isShow != pair.1.isShow
      }
   }

   private func showContent(_ visible: Bool) {
      tableView.isHidden = !visible
      buttonStack.isHidden = !visible
   }

   private func setLoading(_ loading: Bool) {
      if loading { activityIndicator.startAnimating() } else { activityIndicator.stopAnimating() }
      tableView.isUserInteractionEnabled = !loading
      reloadButton.isEnabled = !loading
      updateButtons(enabled: !loading)
   }

   private func updateButtons(enabled: Bool = true) {
      saveButton.isEnabled = enabled && hasChanges
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
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      "Toggle visibility and drag to change order"
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let identifier = "SportAdjustCell"
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
         ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      let item = items[indexPath.row]
      let toggle = UISwitch()
      toggle.tag = indexPath.row
      toggle.isOn = item.isShow
      toggle.addTarget(self, action: #selector(visibilityChanged(_:)), for: .valueChanged)
      cell.textLabel?.text = sportName(item.type)
      cell.detailTextLabel?.text = "Position \(indexPath.row + 1) · \(item.isShow ? "Shown" : "Hidden")"
      cell.accessoryView = toggle
      return cell
   }

   func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { .none }
   func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { false }

   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let item = items.remove(at: sourceIndexPath.row)
      items.insert(item, at: destinationIndexPath.row)
      tableView.reloadData()
      updateButtons()
   }
}
