//
//  CalendarV2ViewController.swift
//  CreekSDK_Example
//

import UIKit
import EventKit
import SnapKit
import CreekSDK

/// Full Calendar V2 demo matching the Flutter example. It reads iOS calendars,
/// lets the user select events, and synchronizes changes in both directions.
final class CalendarV2ViewController: CreekBaseViewController {
   private let service = CalendarV2SyncService()
   private let authorizeButton = UIButton(type: .system)
   private let refreshButton = UIButton(type: .system)
   private let limitLabel = UILabel()
   private let statusLabel = UILabel()
   private let tableView = UITableView(frame: .zero, style: .insetGrouped)
   private let syncButton = UIButton(type: .system)
   private let activityIndicator = UIActivityIndicatorView(style: .large)

   private var snapshot: CalendarV2FirmwareSnapshot?
   private var systemEvents: [CalendarV2SystemEvent] = []
   private var selectedSystemIds: Set<String> = []
   private var isLoading = false
   private var isSyncing = false

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Calendar V2"
      setupUI()
      loadCalendarData()
   }

   private func setupUI() {
      configureButton(authorizeButton, title: "Authorize system calendar", action: #selector(authorizeCalendar))
      configureButton(refreshButton, title: "Refresh", action: #selector(refreshCalendar))

      let buttonStack = UIStackView(arrangedSubviews: [authorizeButton, refreshButton])
      buttonStack.axis = .horizontal
      buttonStack.distribution = .fillEqually
      buttonStack.spacing = 10

      limitLabel.font = .systemFont(ofSize: 13, weight: .medium)
      limitLabel.textColor = .secondaryLabel
      limitLabel.numberOfLines = 0
      limitLabel.text = "System max: --   Local max: --   Batch max: --"

      statusLabel.font = .systemFont(ofSize: 13)
      statusLabel.textColor = .secondaryLabel
      statusLabel.numberOfLines = 0
      statusLabel.text = "Loading device and system calendars..."

      let headerStack = UIStackView(arrangedSubviews: [buttonStack, limitLabel, statusLabel])
      headerStack.axis = .vertical
      headerStack.spacing = 10

      tableView.dataSource = self
      tableView.delegate = self
      tableView.rowHeight = 82

      syncButton.setTitle("Sync both directions", for: .normal)
      syncButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
      syncButton.setTitleColor(.white, for: .normal)
      syncButton.backgroundColor = .systemBlue
      syncButton.layer.cornerRadius = 10
      syncButton.addTarget(self, action: #selector(syncBothDirections), for: .touchUpInside)

      activityIndicator.hidesWhenStopped = true

      view.addSubview(headerStack)
      view.addSubview(tableView)
      view.addSubview(syncButton)
      view.addSubview(activityIndicator)

      headerStack.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
         make.left.right.equalToSuperview().inset(16)
      }
      buttonStack.snp.makeConstraints { make in
         make.height.equalTo(38)
      }
      syncButton.snp.makeConstraints { make in
         make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
         make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
         make.height.equalTo(48)
      }
      tableView.snp.makeConstraints { make in
         make.top.equalTo(headerStack.snp.bottom).offset(6)
         make.left.right.equalToSuperview()
         make.bottom.equalTo(syncButton.snp.top).offset(-6)
      }
      activityIndicator.snp.makeConstraints { make in
         make.center.equalToSuperview()
      }
   }

   private func configureButton(_ button: UIButton, title: String, action: Selector) {
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
      button.backgroundColor = .secondarySystemBackground
      button.layer.cornerRadius = 8
      button.addTarget(self, action: action, for: .touchUpInside)
   }

   private func loadCalendarData() {
      guard !isLoading && !isSyncing else { return }
      isLoading = true
      statusLabel.text = "Loading device and system calendars..."
      updateUI()

      service.getFirmwareSnapshot { [weak self] result in
         DispatchQueue.main.async {
            guard let self = self else { return }
            switch result {
            case .failure(let error):
               self.snapshot = nil
               self.statusLabel.text = "Unable to load device calendars: \(error.localizedDescription)"
            case .success(let snapshot):
               self.snapshot = snapshot
               self.loadSystemCalendar(snapshot: snapshot)
               return
            }
            self.isLoading = false
            self.updateUI()
         }
      }
   }

   private func loadSystemCalendar(snapshot: CalendarV2FirmwareSnapshot) {
      do {
         systemEvents = try service.getSystemEvents()
         let availableIds = Set(systemEvents.map(\.id))
         let syncedIds = snapshot.items
            .filter { $0.origin == .calendarOriginSystem && !$0.deleted }
            .map { String(decoding: $0.id, as: UTF8.self) }
            .filter { availableIds.contains($0) }
         selectedSystemIds = Set(syncedIds.prefix(Int(snapshot.systemMax)))
         statusLabel.text = service.hasCalendarAccess
            ? "Select iOS events below, then sync changes in both directions."
            : "Authorize calendar access to read iOS events."
      } catch {
         systemEvents = []
         selectedSystemIds = []
         statusLabel.text = error.localizedDescription
      }
      isLoading = false
      updateUI()
   }

   private func updateUI() {
      if let snapshot = snapshot {
         limitLabel.text = "System max: \(snapshot.systemMax)   Local max: \(snapshot.localMax)   Batch max: \(snapshot.batchMax)"
      } else {
         limitLabel.text = "System max: --   Local max: --   Batch max: --"
      }
      let busy = isLoading || isSyncing
      authorizeButton.isEnabled = !busy
      refreshButton.isEnabled = !busy
      tableView.isUserInteractionEnabled = !busy
      syncButton.isEnabled = !busy && service.hasCalendarAccess && (snapshot?.systemMax ?? 0) > 0
      syncButton.alpha = syncButton.isEnabled ? 1 : 0.5
      syncButton.setTitle(isSyncing ? "Syncing..." : "Sync both directions", for: .normal)
      if busy { activityIndicator.startAnimating() } else { activityIndicator.stopAnimating() }
      tableView.reloadData()
   }

   private func toggleSystemEvent(at indexPath: IndexPath) {
      guard systemEvents.indices.contains(indexPath.row), let snapshot = snapshot else { return }
      let id = systemEvents[indexPath.row].id
      if selectedSystemIds.contains(id) {
         selectedSystemIds.remove(id)
      } else {
         guard selectedSystemIds.count < Int(snapshot.systemMax) else {
            showMessage(title: "Limit Reached", message: "The device supports up to \(snapshot.systemMax) selected system events.")
            return
         }
         selectedSystemIds.insert(id)
      }
      tableView.reloadSections(IndexSet(integer: 1), with: .none)
   }

   private func firmwareSubtitle(_ item: calendar_v2_item) -> String {
      let source = String(decoding: item.calendarSource, as: UTF8.self)
      let origin = item.origin == .calendarOriginSystem ? "Phone system" : "Firmware local"
      let state = item.deleted ? " · Pending deletion" : ""
      return "\(source.isEmpty ? origin : source)\(state)\n\(dateText(item))"
   }

   private func dateText(_ item: calendar_v2_item) -> String {
      String(format: "%04d-%02d-%02d %02d:%02d - %02d:%02d", item.startYear, item.startMonth, item.startDay, item.startHour, item.startMinute, item.endHour, item.endMinute)
   }

   private func dateText(_ event: CalendarV2SystemEvent) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = event.allDay ? "yyyy-MM-dd · All day" : "yyyy-MM-dd HH:mm"
      let start = formatter.string(from: event.start)
      if event.allDay { return start }
      formatter.dateFormat = "HH:mm"
      return "\(start) - \(formatter.string(from: event.end))"
   }

   private func showMessage(title: String, message: String) {
      guard presentedViewController == nil else { return }
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
   }

   @objc private func authorizeCalendar() {
      service.requestCalendarAccess { [weak self] granted in
         guard let self = self else { return }
         self.statusLabel.text = granted ? "Calendar access granted" : "Calendar access denied"
         if granted { self.loadCalendarData() } else { self.updateUI() }
      }
   }

   @objc private func refreshCalendar() {
      loadCalendarData()
   }

   @objc private func syncBothDirections() {
      guard !isSyncing else { return }
      isSyncing = true
      statusLabel.text = "Synchronizing firmware and iOS calendars..."
      updateUI()
      service.sync(selectedSystemIds: selectedSystemIds) { [weak self] result in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.isSyncing = false
            switch result {
            case .failure(let error):
               self.statusLabel.text = "Sync failed: \(error.localizedDescription)"
               self.updateUI()
            case .success(let result):
               self.statusLabel.text = result.totalChanges == 0
                  ? "Calendars are already up to date"
                  : "Sync completed: \(result.totalChanges) change(s)"
               self.loadCalendarData()
            }
         }
      }
   }
}

extension CalendarV2ViewController: UITableViewDataSource, UITableViewDelegate {
   func numberOfSections(in tableView: UITableView) -> Int { 2 }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 { return max(snapshot?.items.count ?? 0, 1) }
      return max(systemEvents.count, 1)
   }

   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if section == 0 { return "Firmware calendars" }
      return "iOS system calendars · Selected \(selectedSystemIds.count)/\(snapshot?.systemMax ?? 0)"
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let identifier = "CalendarV2Cell"
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
         ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      cell.textLabel?.textColor = .label
      cell.detailTextLabel?.textColor = .secondaryLabel
      cell.detailTextLabel?.numberOfLines = 2
      cell.accessoryType = .none
      cell.selectionStyle = .none

      if indexPath.section == 0 {
         guard let items = snapshot?.items, items.indices.contains(indexPath.row) else {
            cell.textLabel?.text = "No firmware calendar records"
            cell.detailTextLabel?.text = nil
            cell.textLabel?.textColor = .secondaryLabel
            return cell
         }
         let item = items[indexPath.row]
         let title = String(decoding: item.content, as: UTF8.self)
         cell.textLabel?.text = title.isEmpty ? "Unnamed calendar" : title
         cell.detailTextLabel?.text = firmwareSubtitle(item)
         cell.imageView?.image = UIImage(systemName: item.deleted ? "trash.circle" : "cpu")
         cell.imageView?.tintColor = item.deleted ? .systemRed : .systemBlue
         return cell
      }

      guard systemEvents.indices.contains(indexPath.row) else {
         cell.textLabel?.text = service.hasCalendarAccess ? "No upcoming system events" : "Calendar permission required"
         cell.detailTextLabel?.text = service.hasCalendarAccess ? nil : "Tap Authorize system calendar above"
         cell.textLabel?.textColor = .secondaryLabel
         return cell
      }
      let event = systemEvents[indexPath.row]
      cell.textLabel?.text = event.title.isEmpty ? "Unnamed calendar" : event.title
      cell.detailTextLabel?.text = "\(event.source)\n\(dateText(event))"
      cell.accessoryType = selectedSystemIds.contains(event.id) ? .checkmark : .none
      cell.selectionStyle = .default
      cell.imageView?.image = UIImage(systemName: "calendar")
      cell.imageView?.tintColor = .systemGray
      return cell
   }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      guard indexPath.section == 1 else { return }
      toggleSystemEvent(at: indexPath)
   }
}
