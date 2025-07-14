//
//  DialPhotoViewController.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/4/9.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import CropViewController
import TZImagePickerController
import AVFoundation

class DialVideoViewController: CreekBaseViewController,CropViewControllerDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate, TZImagePickerControllerDelegate {
   
   var height = 466
   var width = 466
   var cornerRadius = 233
   var dialParseModel:DialVideoParseModel?
   var croppingStyle:TOCropViewCroppingStyle = .default
   
   lazy var scrollView:UIScrollView = {
      let aview = UIScrollView()
      aview.keyboardDismissMode = .onDrag
      return aview
   }()
   
   lazy var connetView:UIView = {
      let aview = UIView()
      return aview
   }()
   
   // 替换 aimageView 为支持循环播放视频的 UIView
   lazy var videoPlayerView: UIView = {
      let view = UIView()
      view.isUserInteractionEnabled = true
      view.backgroundColor = .red
      let tap = UITapGestureRecognizer(target: self, action: #selector(selectVideo))
      view.addGestureRecognizer(tap)
      return view
   }()
   
   lazy var perView: UIImageView = {
      let view = UIImageView()
      return view
   }()
   
   private var player: AVPlayer?
   private var playerLayer: AVPlayerLayer?
   private var playerLooper: Any?
   
   func playVideo(url: URL) {
      // 移除旧的 playerLayer
      playerLayer?.removeFromSuperlayer()
      player = AVPlayer(url: url)
      playerLayer = AVPlayerLayer(player: player)
      playerLayer?.frame = videoPlayerView.bounds
      playerLayer?.videoGravity = .resizeAspectFill
      if let layer = playerLayer {
         videoPlayerView.layer.addSublayer(layer)
      }
      // 循环播放
      NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
      player?.play()
      videoPlayerView.bringSubviewToFront(perView)
   }
   
   @objc private func loopVideo() {
      player?.seek(to: .zero)
      player?.play()
   }
   
   
   
   lazy var positionView :ZBSlideBackgroundView = {
      let aview = ZBSlideBackgroundView.init(frame: CGRect.zero)
      aview.titleName = "position"
      aview.isUserInteractionEnabled = true
      aview.backgroundColor = .red
      aview.callback = {
         CreekInterFace.instance.setCurrentVideoClockPosition(selectIndex: $0) { model in
            self.dialParseModel = model
            self.setDialUI()
         }
      }
      return aview
   }()
   
   
   lazy var colorView:ZBSlideColorView = {
      let aview = ZBSlideColorView.init(frame: CGRect.zero)
      aview.callback = {
         print($0)
         CreekInterFace.instance.setCurrentVideoColor(selectIndex: $0) { model in
            self.dialParseModel = model
            self.setDialUI()
         }
      }
      return aview
   }()
   
   @objc func selectVideo(){
      showUIImagePickerController()
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setRightBut()
      scrollView.backgroundColor = .yellow
      self.view.addSubview(scrollView)
      
      self.scrollView.addSubview(videoPlayerView)
      videoPlayerView.addSubview(perView)
      self.scrollView.addSubview(colorView)
      self.scrollView.addSubview(positionView)
      scrollView.snp.makeConstraints {
         $0.left.right.top.equalTo(self.view)
         $0.bottom.equalTo(self.view).offset(-64-SAFEAREAINSETS.bottom)
         
      }
     
      videoPlayerView.snp.makeConstraints {
         $0.top.equalTo(scrollView.snp.top).offset(FBScale(40))
         $0.centerX.equalTo(self.scrollView)
         $0.width.equalTo(FBScale(CGFloat(self.width)))
         $0.height.equalTo(FBScale(CGFloat(self.height)))
      }
    
      perView.snp.makeConstraints {
         $0.top.bottom.left.right.equalTo(videoPlayerView)
      }
      colorView.snp.makeConstraints {
         $0.top.equalTo(videoPlayerView.snp.bottom).offset(FBScale(20))
         $0.height.equalTo(FBScale(300))
         $0.left.right.equalTo(self.view)
      }
      positionView.snp.makeConstraints {
         $0.top.equalTo(colorView.snp.bottom).offset(FBScale(20))
         $0.height.equalTo(FBScale(600))
         $0.left.right.equalTo(self.view)
         $0.bottom.equalTo(scrollView.snp.bottom).offset(-FBScale(20))
      }
      setDialUI()
      unzipFile()
   }
   
   func setDialUI(){
      videoPlayerView.layer.cornerRadius = FBScale(CGFloat(cornerRadius))
      videoPlayerView.layer.masksToBounds = true
      videoPlayerView.snp.removeConstraints()
      videoPlayerView.snp.makeConstraints {
         $0.top.equalTo(scrollView.snp.top).offset(FBScale(40))
         $0.centerX.equalTo(self.scrollView)
         $0.width.equalTo(FBScale(CGFloat(self.width)))
         $0.height.equalTo(FBScale(CGFloat(self.height)))
      }
      
      perView.layer.cornerRadius = FBScale(CGFloat(cornerRadius))
      perView.layer.masksToBounds = true
      perView.snp.removeConstraints()
      perView.snp.makeConstraints {
         $0.top.bottom.left.right.equalTo(videoPlayerView)
      }
      if let mode = dialParseModel {
         colorView.itemsTitle = mode.appColors!
         if !mode.colorSelectIndexList.isEmpty{
            colorView.slideBarItemSelected(index: mode.colorSelectIndexList[mode.videoSelectIndex ?? 0])
         }
         
         positionView.width = FBScale(CGFloat(width))
         positionView.height = FBScale(CGFloat(height))
         positionView.cornerRadius = FBScale(CGFloat(cornerRadius))
         positionView.itemsTitle = mode.clockPositionImagePaths
         if !mode.clockPositionSelectIndexList.isEmpty{
            positionView.slideBarItemSelected(index: mode.clockPositionSelectIndexList[mode.videoSelectIndex ?? 0])
         }
         if let data = Data(base64Encoded: mode.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
            if let image = UIImage(data: data) {
               perView.image = image
            }
         }
      }

   }
   
   func setRightBut() {
      let right = UIBarButtonItem(title: "Install", style: .plain, target: self, action: #selector(rightClick))
      self.navigationItem.rightBarButtonItems = [right]
      
   }
   
   
   @objc func rightClick(){
      CreekInterFace.instance.encodeVideoDial { model in
         CreekInterFace.instance.upload(fileName: "video.bin", fileData: model) { progress in
            print(progress)
         } uploadSuccess: {
            print("uploadSuccess")
         } uploadFailure: { code, message in
            print(message)
         }
      }
   }
   
   func unzipFile(){
      var macAddress = ""
      let titleName = "video"
      CreekInterFace.instance.getFirmware { model in
         self.width = Int(model.sizeInfo.width)
         self.height = Int(model.sizeInfo.height)
         self.cornerRadius = Int(model.sizeInfo.angle)
         self.croppingStyle = .circular
         
         if let path =  Bundle.main.path(forResource: titleName, ofType: "zip"){
            let fileManager = FileManager()
            if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
               var destinationURL = documentsURL
               print(convertDataToMACAddress(model.macAddr))
               if convertDataToMACAddress(model.macAddr) != ""{
                  macAddress = convertDataToMACAddress(model.macAddr)
                  destinationURL.appendPathComponent("directory/\(macAddress)")
               }else{
                  print("Failed to create file")
                  return
               }
               if !self.isDirectoryExists(at: destinationURL) {
                  do {
                     try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                     try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL)
                     
                     print("Decompression is successful, the path is:\(destinationURL.path)")
                  } catch {
                     print("Decompression failed: \(error)")
                  }
               } else {
                  var destinationURL2 = destinationURL
                  destinationURL2.appendPathComponent(titleName)
                  if !self.isDirectoryExists(at: destinationURL2) {
                     do {
                        try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL)
                        print("Decompression is successful, the path is:\(destinationURL.path)")
                     } catch {
                        print("Decompression failed: \(error)")
                     }
                  }else{
                     print("The file already exists")
                  }
               }
            }
            
         }else{
            print("file does not exist")
         }
         
         if macAddress != "" || titleName != ""{
            self.parseDial(mac: macAddress,name: titleName)
         }
         
      } failure: { code, message in
         
      }

   }
   
   func parseDial(mac:String,name:String){
      let fileManager = FileManager()
      if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
         var destinationURL = documentsURL
         destinationURL.appendPathComponent("directory/\(mac)/\(name)")
         CreekInterFace.instance.parseVideoDial(destinationURL.path, width, height, cornerRadius,.jx3085CPlatform){ [weak self] model in
            self?.dialParseModel = model
            self?.setDialUI()
            if (model.videoPath ?? "") != ""{
               self?.playVideo(url: URL(fileURLWithPath: model.videoPath!))
            }
         }
      }
   }
   
   func isDirectoryExists(at url: URL) -> Bool {
      var isDirectory: ObjCBool = false
      return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
   }
   
   func goCamera(){
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         let  cameraPicker = UIImagePickerController()
         cameraPicker.delegate = self
         cameraPicker.allowsEditing = true
         cameraPicker.sourceType = .camera
         self.present(cameraPicker, animated: true, completion: nil)
      } else {
         print("Not supported for taking pictures")
      }
   }
   
   func showUIImagePickerController() {
      
      let imagePickerVc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
      imagePickerVc?.allowCrop = true
      
      let size = SCREENW - 40
      let offsetY = (SCREENH - size)/2
      imagePickerVc?.cropRect = CGRect(x: 20, y: offsetY, width: size, height: size)
      imagePickerVc?.allowPickingOriginalPhoto = false
      imagePickerVc?.allowPickingGif = false
      imagePickerVc?.allowPickingVideo = true
      imagePickerVc?.allowPickingImage = false
      imagePickerVc?.modalPresentationStyle = .fullScreen
      self.present(imagePickerVc ?? TZImagePickerController(), animated: true) {
         
      }
   }
   
   func showUIImagePickerController2(image:UIImage) {
      let cropViewController = CropViewController(croppingStyle: croppingStyle,image: image)
      cropViewController.delegate = self
      cropViewController.cropView.backgroundColor = .gray
      let cropSize = CGSize(width: FBScale(CGFloat(width)) , height: FBScale(CGFloat(height))) // custom size
      cropViewController.cropView.cropBoxResizeEnabled = false // Disable crop box resizing
      cropViewController.cropView.frame = CGRect(origin: .zero, size: cropSize)
      cropViewController.cropView.alpha = 0.5
      self.present(cropViewController, animated: true, completion: nil)
   }
   func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
      cropViewController.dismiss(animated: true, completion: nil)
   }
   func cropViewController(_ cropViewController: CropViewController, didCropImageToRect cropRect: CGRect, angle: Int) {
      print("Clipping area coordinates: \(cropRect)")
      cropViewController.dismiss(animated: true, completion: nil)
      CreekInterFace.instance.setVideoDial(saveVideoPath, 0, 3, cropRect.size.width, cropRect.size.height, cropRect.origin.x, cropRect.origin.y) { videoPath in
         print("生成的视频地址:\(videoPath)")
         // 自动播放
         dispatch_main_sync_safe {
            self.playVideo(url: URL(fileURLWithPath: videoPath))
         }
         CreekInterFace.instance.setCurrentVideoColor(selectIndex: 0) { model in
            self.dialParseModel = model
            self.setDialUI()
            
         }
      } failure: { code, message in
         print("失败:\(message)")
      }
   }
   
   
   func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
      if !photos.isEmpty{
         picker.dismiss(animated: true, completion: {
            self.showUIImagePickerController2(image: photos[0])
         })
      }
   }
   
   private func generateThumbnail(from asset: AVAsset) -> UIImage? {
      let generator = AVAssetImageGenerator(asset: asset)
      generator.appliesPreferredTrackTransform = true
      generator.apertureMode = .encodedPixels
      do {
         let time = CMTime(seconds: 1, preferredTimescale: 600)
         let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
         return UIImage(cgImage: imageRef)
      } catch {
         print("failure：\(error)")
         return nil
      }
   }
   
   func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
      
      PHImageManager.default().requestAVAsset(forVideo: asset, options: nil) { [weak self] (avAsset, _, _) in
         guard let self = self,
               let urlAsset = avAsset as? AVURLAsset else { return }
         
         let videoURL = urlAsset.url
         
         
         // Save the video file to local
         self.saveVideoToLocal(videoURL: videoURL)
         
         //
         if let image = self.generateThumbnail(from: urlAsset) {
            DispatchQueue.main.async {
               self.showUIImagePickerController2(image: image)
            }
         }
      }
   }
   
   var saveVideoPath = ""
   func saveVideoToLocal(videoURL: URL) {
      let fileManager = FileManager.default
      if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
         let fileExtension = videoURL.pathExtension
         let fileName = "video.\(fileExtension)"
         let destinationURL = documentsDirectory.appendingPathComponent(fileName)
         do {
            //If it already exists, delete it first
            if fileManager.fileExists(atPath: destinationURL.path) {
               try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: videoURL, to: destinationURL)
            saveVideoPath = destinationURL.absoluteString
            print("Video saved successfully: \(destinationURL)")
         } catch {
            print("Failed to save video: \(error)")
         }
      }
   }
   
}
