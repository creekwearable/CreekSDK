//
//  MusicViewController.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/4/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation
import UniformTypeIdentifiers
import SnapKit

class MusicUploadViewController: UIViewController, UIDocumentPickerDelegate {
    
    private let chooseFileButton = UIButton(type: .system)
    private let infoLabel = UILabel()
    private let uploadButton = UIButton(type: .system)
    private var songName = ""
    private var singer = ""
    private var selectedFileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "music upload"
        setupUI()
    }
   
    private func setupUI() {
        // 选择文件按钮
        chooseFileButton.setTitle("select file", for: .normal)
        chooseFileButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        chooseFileButton.addTarget(self, action: #selector(selectFileTapped), for: .touchUpInside)
        view.addSubview(chooseFileButton)

        // 信息标签
        infoLabel.text = "singer name:, album Name:"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .darkGray
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(infoLabel)

        // 上传按钮
        uploadButton.setTitle("start upload", for: .normal)
        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        uploadButton.addTarget(self, action: #selector(startUpload), for: .touchUpInside)
        view.addSubview(uploadButton)

        // SnapKit 布局
        chooseFileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(chooseFileButton.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }

   @objc private func selectFileTapped() {
       if #available(iOS 14.0, *) {
           let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
           picker.delegate = self
           picker.modalPresentationStyle = .formSheet
           present(picker, animated: true, completion: nil)
       } else {
           let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
           picker.delegate = self
           picker.modalPresentationStyle = .formSheet
           present(picker, animated: true, completion: nil)
       }
   }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        self.selectedFileURL = url
        parseAudioMetadata(from: url)
    }

    private func parseAudioMetadata(from url: URL) {
        let asset = AVAsset(url: url)
        let metadata = asset.commonMetadata
        
        singer = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierArtist).first?.stringValue ?? ""
        songName = AVMetadataItem.metadataItems(from: metadata, filteredByIdentifier: .commonIdentifierAlbumName).first?.stringValue ?? ""
        
        infoLabel.text = "singer name: \(singer), album Name: \(songName)"
    }

    @objc private func startUpload() {
        guard let fileURL = selectedFileURL else {
            infoLabel.text = "Please select a file"
            return
        }
       
       if let fileData = try? Data(contentsOf: fileURL){
          CreekInterFace.instance.uploadMusic(musicModel: CreekMusicModel(songName: songName,singer: singer,audioType: .mp3), fileData: fileData) { progress in
             self.infoLabel.text = "progress : \(progress)"
          } uploadSuccess: {
             self.infoLabel.text = "Success"
          } uploadFailure: { code, message in
             self.infoLabel.text = "Failure"
          }
       }else{
          self.infoLabel.text = "no file data"
       }

    }
}

