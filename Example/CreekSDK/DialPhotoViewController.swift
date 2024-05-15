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

class DialPhotoViewController: CreekBaseViewController,CropViewControllerDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate, TZImagePickerControllerDelegate {
    
    var height = 448
    var width = 368
    var cornerRadius = 60
    var dialParseModel:DialPhotoParseModel?
    
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
    
    lazy var aimageView:UIImageView = {
        let aview = UIImageView()
        aview.isUserInteractionEnabled = true
        aview.layer.cornerRadius = FBScale(60)
        aview.layer.masksToBounds = true
        aview.backgroundColor = .red
        return aview
    }()
    
    lazy var photoView :ZBSlideBackgroundPhotoView = {
        let aview = ZBSlideBackgroundPhotoView.init(frame: CGRect.zero)
        aview.isUserInteractionEnabled = true
        aview.backgroundColor = .red
        aview.callback = {
            if (self.dialParseModel?.photoImagePaths.count ?? 0) == $0{
                self.cameraView.showSheetView()
                return
            }
            self.dialParseModel?.photoSelectIndex = $0
            CreekInterFace.instance.setCurrentPhotoBackgroundImagePath(photoImagePaths: self.dialParseModel?.photoImagePaths ?? [], selectIndex: self.dialParseModel?.photoSelectIndex ?? 0) { model in
                self.dialParseModel = model
                self.setDialUI()
            }
        }
        return aview
    }()
    
    lazy var positionView :ZBSlideBackgroundView = {
        let aview = ZBSlideBackgroundView.init(frame: CGRect.zero)
        aview.titleName = "position"
        aview.isUserInteractionEnabled = true
        aview.backgroundColor = .red
        aview.callback = {
            CreekInterFace.instance.setCurrentClockPosition(photoSelectIndex: self.dialParseModel?.photoSelectIndex ?? 0, selectIndex: $0) { model in
                self.dialParseModel = model
                self.setDialUI()
            }
        }
        return aview
    }()
    
    lazy var cameraView:CameraPopView = {
        let popView = CameraPopView.init(frame: CGRect(x: 0, y: 0, width: SCREENW, height: SCREENH),height: 188)
        popView.block = ({[weak self] (cameraType) in
            self?.view.endEditing(true)
            if cameraType == .CameraTypeShoot {
                self?.goCamera()
            } else if cameraType == .CameraTypeAlbum {
                self?.showUIImagePickerController()
            }
        })
        return popView
    }()
    
    lazy var colorView:ZBSlideColorView = {
        let aview = ZBSlideColorView.init(frame: CGRect.zero)
        aview.callback = {
           print($0)
            CreekInterFace.instance.setCurrentPhotoColor(photoSelectIndex: self.dialParseModel?.photoSelectIndex ?? 0, selectIndex: $0) { model in
                self.dialParseModel = model
                self.setDialUI()
            }
        }
        return aview
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBut()
        scrollView.backgroundColor = .yellow
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(aimageView)
        self.scrollView.addSubview(photoView)
        self.scrollView.addSubview(colorView)
        self.scrollView.addSubview(positionView)
        scrollView.snp.makeConstraints {
            $0.left.right.top.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-64-SAFEAREAINSETS.bottom)

        }
        aimageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(FBScale(40))
            $0.centerX.equalTo(self.scrollView)
            $0.width.equalTo(FBScale(CGFloat(self.width)))
            $0.height.equalTo(FBScale(CGFloat(self.height)))
        }
        photoView.snp.makeConstraints {
            $0.top.equalTo(aimageView.snp.bottom).offset(FBScale(20))
            $0.height.equalTo(FBScale(600))
            $0.left.right.equalTo(self.view)
        }
        colorView.snp.makeConstraints {
            $0.top.equalTo(photoView.snp.bottom).offset(FBScale(20))
            $0.height.equalTo(FBScale(300))
            $0.left.right.equalTo(self.view)
        }
        positionView.snp.makeConstraints {
            $0.top.equalTo(colorView.snp.bottom).offset(FBScale(20))
            $0.height.equalTo(FBScale(600))
            $0.left.right.equalTo(self.view)
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-FBScale(20))
        }
        
        unzipFile()
        
    }
    
    func setDialUI(){
        if let mode = dialParseModel {
            colorView.itemsTitle = mode.appColors!
            if !mode.colorSelectIndexList.isEmpty{
                colorView.slideBarItemSelected(index: mode.colorSelectIndexList[mode.photoSelectIndex ?? 0])
            }
            
            positionView.width = FBScale(CGFloat(width))
            positionView.height = FBScale(CGFloat(height))
            positionView.cornerRadius = FBScale(CGFloat(cornerRadius))
            positionView.itemsTitle = mode.clockPositionImagePaths
            if !mode.clockPositionSelectIndexList.isEmpty{
                positionView.slideBarItemSelected(index: mode.clockPositionSelectIndexList[mode.photoSelectIndex ?? 0])
            }
            
            photoView.width = FBScale(CGFloat(width))
            photoView.height = FBScale(CGFloat(height))
            photoView.cornerRadius = FBScale(CGFloat(cornerRadius))
            photoView.itemsTitle = mode.photoImagePaths
            
            photoView.slideBarItemSelected(index: mode.photoSelectIndex ?? 0)
            
            if let data = Data(base64Encoded: mode.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
                if let image = UIImage(data: data) {
                    aimageView.image = image
                }
            }
        }
        aimageView.layer.cornerRadius = FBScale(CGFloat(cornerRadius))
        aimageView.layer.masksToBounds = true
        aimageView.snp.removeConstraints()
        aimageView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(FBScale(40))
            $0.centerX.equalTo(self.scrollView)
            $0.width.equalTo(FBScale(CGFloat(self.width)))
            $0.height.equalTo(FBScale(CGFloat(self.height)))
        }
   
       
    }
    
    func setRightBut() {
        let right = UIBarButtonItem(title: "Install", style: .plain, target: self, action: #selector(rightClick))
       let right2 = UIBarButtonItem(title: "rem", style: .plain, target: self, action: #selector(rightClick2))
        self.navigationItem.rightBarButtonItems = [right,right2]
        
    }

    @objc func rightClick(){
        if (self.dialParseModel?.photoImagePaths.count ?? 0 == 0){
            CreekAlert.alertMsg(exception: "The background image is empty")
            return
        }
        CreekInterFace.instance.encodePhotoDial { model in
            CreekInterFace.instance.upload(fileName: "photo.bin", fileData: model) { progress in
               print(progress)
            } uploadSuccess: {
                print("uploadSuccess")
            } uploadFailure: { code, message in
                print(message)
            }

        }
       
    }
   @objc func rightClick2(){
      if((self.dialParseModel?.photoImagePaths ?? []).count > 1){
         self.dialParseModel?.photoImagePaths.removeLast()
         CreekInterFace.instance.setCurrentPhotoBackgroundImagePath(photoImagePaths: self.dialParseModel?.photoImagePaths ?? [], selectIndex: 0) { model in
             self.dialParseModel = model
             self.setDialUI()
         }
      }else{
         CreekAlert.alertMsg(exception: "There must be at least one background")
      }
      
      
     
      
   }
    
    func unzipFile(){
        var macAddress = ""
        var titleName = ""
        CreekInterFace.instance.getFirmware { model in
            self.width = Int(model.sizeInfo.width)
            self.height = Int(model.sizeInfo.height)
            self.cornerRadius = Int(model.sizeInfo.angle)
            if model.sizeInfo.height == 448 && model.sizeInfo.width == 368 && model.sizeInfo.angle == 60{
                titleName = "squarePhoto"
                self.croppingStyle = .default
            }else if(model.sizeInfo.height == 466 && model.sizeInfo.width == 466 && model.sizeInfo.angle == 233){
                titleName = "circlePhoto"
                self.croppingStyle = .circular
            }
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
            CreekInterFace.instance.parsePhotoDial(destinationURL.path, width, height, cornerRadius,.jx3085CPlatform){ [weak self] model in
                self?.dialParseModel = model
                self?.setDialUI()
                dispatch_main_sync_safe {
                    if let data = Data(base64Encoded: model.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
                       
                        if let image = UIImage(data: data) {
                            self?.aimageView.image = image
                        } else {
                            print("Failed to create UIImage from base64 encoded string")
                        }
                    } else {
                        print("Failed to convert base64 string to Data")
                    }
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
        imagePickerVc?.allowPickingOriginalPhoto = true
        imagePickerVc?.allowPickingGif = false
        imagePickerVc?.allowPickingVideo = false
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
        
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        dispatch_main_sync_safe {
            self.aimageView.image = image
        }
        cropImage(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
       
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        dispatch_main_sync_safe {
            self.aimageView.image = image
        }
        cropImage(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
  
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        if !photos.isEmpty{
            picker.dismiss(animated: true, completion: {
                self.showUIImagePickerController2(image: photos[0])
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        let photos:[UIImage] = [image]
        if !photos.isEmpty{
            picker.dismiss(animated: true, completion: {
                self.showUIImagePickerController2(image: photos[0])
            })
        }
    }
    
    ///存储裁剪图片的目录
    func  cropImage(image:UIImage){
        
        let resizedImage = resizeImage(image: image)
        guard let data = resizedImage.pngData() else {
            print("Unable to convert image to PNG data")
            return
        }
        let fileManager = FileManager()
           if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
               var destinationURL = documentsURL
               destinationURL.appendPathComponent("\(arc4random_uniform(10000) + 1)\(arc4random_uniform(10000) + 1).png")
               do {
                    try data.write(to: destinationURL)
                   self.dialParseModel?.photoImagePaths.append(destinationURL.path)
                   self.dialParseModel?.photoSelectIndex = (self.dialParseModel?.photoImagePaths.count ?? 0) - 1
                   CreekInterFace.instance.setCurrentPhotoBackgroundImagePath(photoImagePaths: self.dialParseModel?.photoImagePaths ?? [], selectIndex: self.dialParseModel?.photoSelectIndex ?? 0) { model in
                       self.dialParseModel = model
                       self.setDialUI()
                   }
                    print("Image saved successfully：\(destinationURL)")
                   
                } catch {
                    print("Failed to save image：\(error.localizedDescription)")
                  
                }
           }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
    }
    
}
