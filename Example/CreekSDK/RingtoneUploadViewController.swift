//
//  RingtoneUploadViewController.swift
//  CreekSDK_Example
//

import UIKit
import UniformTypeIdentifiers
import SnapKit
import CreekSDK

/// Complete ringtone demo: select, convert, upload, list, set default and delete.
final class RingtoneUploadViewController: CreekBaseViewController, UIDocumentPickerDelegate {
   private let chooseButton = UIButton(type: .system)
   private let fileLabel = UILabel()
   private let hintLabel = UILabel()
   private let uploadButton = UIButton(type: .system)
   private let progressView = UIProgressView(progressViewStyle: .default)
   private let statusLabel = UILabel()
   private let listTitleLabel = UILabel()
   private let spaceLabel = UILabel()
   private let listIndicator = UIActivityIndicatorView(style: .medium)
   private let tableView = UITableView(frame: .zero, style: .insetGrouped)

   private var selectedFileURL: URL?
   private var sourceData: Data?
   private var ringtoneInfo: protocol_ringtone_inquire_reply?
   private var isProcessing = false
   private var isListLoading = false

   private var ringtoneItems: [protocol_ringtone_item] {
      ringtoneInfo?.items ?? []
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Ringtone"
      setupUI()
      updateUI()
      refreshRingtones()
   }

   private func setupUI() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
         barButtonSystemItem: .refresh,
         target: self,
         action: #selector(refreshButtonTapped)
      )

      chooseButton.setTitle("Select audio file", for: .normal)
      chooseButton.contentHorizontalAlignment = .left
      chooseButton.addTarget(self, action: #selector(chooseAudio), for: .touchUpInside)

      fileLabel.text = "No file selected"
      fileLabel.numberOfLines = 1
      fileLabel.lineBreakMode = .byTruncatingMiddle
      fileLabel.backgroundColor = .secondarySystemBackground
      fileLabel.layer.cornerRadius = 10
      fileLabel.layer.masksToBounds = true

      hintLabel.text = "Audio longer than 10 seconds will be trimmed during conversion."
      hintLabel.font = .systemFont(ofSize: 13)
      hintLabel.textColor = .secondaryLabel
      hintLabel.numberOfLines = 0

      uploadButton.setTitle("Upload ringtone", for: .normal)
      uploadButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
      uploadButton.backgroundColor = .systemBlue
      uploadButton.setTitleColor(.white, for: .normal)
      uploadButton.layer.cornerRadius = 10
      uploadButton.addTarget(self, action: #selector(startUpload), for: .touchUpInside)

      statusLabel.text = "Select an audio file to begin"
      statusLabel.font = .systemFont(ofSize: 13)
      statusLabel.textColor = .secondaryLabel
      statusLabel.numberOfLines = 0

      listTitleLabel.text = "Device ringtones"
      listTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)

      spaceLabel.font = .systemFont(ofSize: 13)
      spaceLabel.textColor = .secondaryLabel
      spaceLabel.text = "Total: --   Remaining: --"

      listIndicator.hidesWhenStopped = true

      tableView.dataSource = self
      tableView.delegate = self
      tableView.rowHeight = 72

      let uploadStack = UIStackView(arrangedSubviews: [
         chooseButton,
         fileLabel,
         hintLabel,
         uploadButton,
         progressView,
         statusLabel
      ])
      uploadStack.axis = .vertical
      uploadStack.spacing = 12

      let listHeader = UIStackView(arrangedSubviews: [listTitleLabel, listIndicator])
      listHeader.axis = .horizontal
      listHeader.alignment = .center
      listHeader.spacing = 8

      view.addSubview(uploadStack)
      view.addSubview(listHeader)
      view.addSubview(spaceLabel)
      view.addSubview(tableView)

      uploadStack.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
         make.left.right.equalToSuperview().inset(16)
      }
      fileLabel.snp.makeConstraints { make in
         make.height.equalTo(40)
      }
      uploadButton.snp.makeConstraints { make in
         make.height.equalTo(44)
      }
      listHeader.snp.makeConstraints { make in
         make.top.equalTo(uploadStack.snp.bottom).offset(20)
         make.left.right.equalToSuperview().inset(16)
      }
      spaceLabel.snp.makeConstraints { make in
         make.top.equalTo(listHeader.snp.bottom).offset(6)
         make.left.right.equalToSuperview().inset(16)
      }
      tableView.snp.makeConstraints { make in
         make.top.equalTo(spaceLabel.snp.bottom).offset(4)
         make.left.right.bottom.equalToSuperview()
      }
   }

   private func updateUI() {
      chooseButton.isEnabled = !isProcessing
      uploadButton.isEnabled = !isProcessing && sourceData?.isEmpty == false
      uploadButton.alpha = uploadButton.isEnabled ? 1 : 0.5
      uploadButton.setTitle(isProcessing ? "Processing..." : "Upload ringtone", for: .normal)
      navigationItem.rightBarButtonItem?.isEnabled = !isProcessing && !isListLoading
      tableView.isUserInteractionEnabled = !isProcessing
      if isListLoading { listIndicator.startAnimating() } else { listIndicator.stopAnimating() }
   }

   private func refreshRingtones() {
      guard !isListLoading else { return }
      isListLoading = true
      updateUI()
      CreekInterFace.instance.getRingtoneList { [weak self] reply in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.ringtoneInfo = reply
            self.isListLoading = false
            self.spaceLabel.text = "Total: \(self.formatSize(reply.totolSize))   Remaining: \(self.formatSize(reply.remainSize))"
            self.tableView.reloadData()
            self.updateUI()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.isListLoading = false
            self?.statusLabel.text = "Unable to load ringtone list (\(code)): \(message)"
            self?.updateUI()
         }
      }
   }

   private func convertAndUpload(_ sourceData: Data, fileURL: URL) {
      isProcessing = true
      progressView.progress = 0
      statusLabel.text = "Converting audio..."
      updateUI()

      CreekInterFace.instance.convertRingtone(fileData: sourceData) { [weak self] convertedData in
         DispatchQueue.main.async {
            guard let self = self else { return }
            guard let info = self.ringtoneInfo else {
               self.finishProcessing(message: "Ringtone storage information is unavailable. Refresh the list and try again.")
               return
            }
            guard UInt64(convertedData.count) <= UInt64(info.remainSize) else {
               self.finishProcessing(
                  message: "Not enough space. Required: \(self.formatSize(UInt32(clamping: convertedData.count))), remaining: \(self.formatSize(info.remainSize))."
               )
               return
            }
            self.upload(convertedData, fileURL: fileURL)
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.finishProcessing(message: "Conversion failed (\(code)): \(message)")
         }
      }
   }

   private func upload(_ convertedData: Data, fileURL: URL) {
      let identifier = UInt32(Date().timeIntervalSince1970)
      let name = fileURL.deletingPathExtension().lastPathComponent
      let model = CreekRingtoneModel(ringtoneId: identifier, ringtoneName: name)
      statusLabel.text = "Uploading ringtone..."

      CreekInterFace.instance.uploadRingtone(model: model, convertedData: convertedData) { [weak self] progress in
         DispatchQueue.main.async {
            self?.progressView.progress = Float(progress) / 100.0
            self?.statusLabel.text = "Uploading: \(progress)%"
         }
      } success: { [weak self] in
         DispatchQueue.main.async {
            guard let self = self else { return }
            self.progressView.progress = 1
            self.finishProcessing(message: "Upload succeeded (ID: \(identifier))")
            self.refreshRingtones()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.finishProcessing(message: "Upload failed (\(code)): \(message)")
         }
      }
   }

   private func setAsDefault(at index: Int) {
      guard ringtoneItems.indices.contains(index) else { return }
      let item = ringtoneItems[index]
      guard !item.isDefault else { return }
      CreekInterFace.instance.setDefaultRingtone(ringtoneId: item.ringtoneID) { [weak self] in
         DispatchQueue.main.async {
            self?.statusLabel.text = "Default ringtone updated"
            self?.refreshRingtones()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.statusLabel.text = "Unable to set default (\(code)): \(message)"
         }
      }
   }

   private func deleteRingtone(at index: Int) {
      guard ringtoneItems.indices.contains(index) else { return }
      let item = ringtoneItems[index]
      guard item.isCustom else {
         statusLabel.text = "Built-in ringtones cannot be deleted"
         return
      }
      CreekInterFace.instance.deleteCustomRingtones(ringtoneIds: [item.ringtoneID]) { [weak self] in
         DispatchQueue.main.async {
            self?.statusLabel.text = "Custom ringtone deleted"
            self?.refreshRingtones()
         }
      } failure: { [weak self] code, message in
         DispatchQueue.main.async {
            self?.statusLabel.text = "Delete failed (\(code)): \(message)"
         }
      }
   }

   private func ringtoneName(_ item: protocol_ringtone_item) -> String {
      let bytes = item.ringtoneName.prefix { $0 != 0 }
      guard !bytes.isEmpty else { return "Ringtone \(item.ringtoneID)" }
      return String(decoding: bytes, as: UTF8.self)
   }

   private func formatSize(_ bytes: UInt32) -> String {
      let value = Double(bytes)
      if bytes < 1024 { return "\(bytes) B" }
      if bytes < 1024 * 1024 { return String(format: "%.1f KB", value / 1024) }
      return String(format: "%.1f MB", value / (1024 * 1024))
   }

   private func finishProcessing(message: String) {
      isProcessing = false
      statusLabel.text = message
      updateUI()
   }

   @objc private func chooseAudio() {
      let picker: UIDocumentPickerViewController
      if #available(iOS 14.0, *) {
         picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
      } else {
         picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
      }
      picker.delegate = self
      picker.modalPresentationStyle = .formSheet
      present(picker, animated: true)
   }

   @objc private func startUpload() {
      guard let data = sourceData, !data.isEmpty, let url = selectedFileURL else {
         statusLabel.text = "Select an audio file first"
         return
      }
      convertAndUpload(data, fileURL: url)
   }

   @objc private func refreshButtonTapped() {
      refreshRingtones()
   }

   @objc private func defaultButtonTapped(_ sender: UIButton) {
      setAsDefault(at: sender.tag)
   }

   @objc private func deleteButtonTapped(_ sender: UIButton) {
      deleteRingtone(at: sender.tag)
   }

   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      guard let url = urls.first else { return }
      do {
         let data = try Data(contentsOf: url)
         guard !data.isEmpty else { throw RingtoneDemoError.emptyFile }
         selectedFileURL = url
         sourceData = data
         progressView.progress = 0
         fileLabel.text = "   \(url.lastPathComponent)"
         statusLabel.text = "Selected: \(formatSize(UInt32(clamping: data.count)))"
         updateUI()
      } catch {
         statusLabel.text = "Unable to read audio: \(error.localizedDescription)"
      }
   }
}

extension RingtoneUploadViewController: UITableViewDataSource, UITableViewDelegate {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      ringtoneItems.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let identifier = "RingtoneCell"
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
         ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
      let item = ringtoneItems[indexPath.row]
      let duration = String(format: "%.1f s", Double(item.durationMs) / 1000)
      cell.textLabel?.text = ringtoneName(item)
      cell.detailTextLabel?.text = "\(item.isCustom ? "Custom" : "Built-in") · \(duration) · \(formatSize(item.fileSize))"
      cell.selectionStyle = .none

      let actions = UIStackView()
      actions.axis = .horizontal
      actions.alignment = .center
      actions.spacing = 6
      actions.frame = CGRect(
         x: 0,
         y: 0,
         width: item.isCustom ? 126 : 86,
         height: 40
      )
      if item.isDefault {
         let label = UILabel()
         label.text = "Default"
         label.font = .systemFont(ofSize: 12, weight: .semibold)
         label.textColor = .systemGreen
         label.textAlignment = .center
         actions.addArrangedSubview(label)
      } else {
         let defaultButton = UIButton(type: .system)
         defaultButton.setTitle("Set", for: .normal)
         defaultButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
         defaultButton.setTitleColor(.white, for: .normal)
         defaultButton.backgroundColor = .systemBlue
         defaultButton.layer.cornerRadius = 7
         defaultButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
         defaultButton.tag = indexPath.row
         defaultButton.addTarget(self, action: #selector(defaultButtonTapped(_:)), for: .touchUpInside)
         actions.addArrangedSubview(defaultButton)
      }
      if item.isCustom {
         let deleteButton = UIButton(type: .system)
         deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
         deleteButton.tintColor = .systemRed
         deleteButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
         deleteButton.layer.cornerRadius = 7
         deleteButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
         deleteButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
         deleteButton.tag = indexPath.row
         deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
         actions.addArrangedSubview(deleteButton)
      }
      cell.accessoryView = actions
      return cell
   }
}

private enum RingtoneDemoError: LocalizedError {
   case emptyFile

   var errorDescription: String? {
      "The selected audio file is empty"
   }
}
