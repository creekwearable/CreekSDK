//
//  DialDetailsViewController.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/1/30.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class DialDetailsViewController: CreekBaseViewController {
    
    var titleName = ""
    
    var dialParseModel:DialParseModel?
    
    var height = 448
    var width = 368
    var cornerRadius = 60
    
    lazy var aimageView:UIImageView = {
        let aview = UIImageView()
        aview.isUserInteractionEnabled = true
        aview.layer.cornerRadius = FBScale(60)
        aview.layer.masksToBounds = true
        aview.backgroundColor = .red
        return aview
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleName
        unzipFile()
        setLayerUI()
        setRightBut()
        
    }
    
    func setRightBut() {
        let right = UIBarButtonItem(title: "Install", style: .plain, target: self, action: #selector(rightClick))
        self.navigationItem.rightBarButtonItem = right
        
    }

    @objc func rightClick(){
        CreekInterFace.instance.encodeDial { model in
            CreekInterFace.instance.upload(fileName: "\(self.titleName).bin", fileData: model) { progress in
               print(progress)
            } uploadSuccess: {
                print("uploadSuccess")
            } uploadFailure: { code, message in
                print(message)
            }

        }
       
    }
    
    func setLayerUI(){
        view.addSubview(aimageView)
        aimageView.layer.cornerRadius = FBScale(CGFloat(self.cornerRadius))
        aimageView.layer.masksToBounds = true
        aimageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(SAFEAREAINSETS.top + 44 + FBScale(40))
            $0.centerX.equalTo(view)
            $0.width.equalTo(FBScale(CGFloat(self.width)))
            $0.height.equalTo(FBScale(CGFloat(self.height)))
        }

    }
    
    //MARK: Unzip file
    func unzipFile(){
        if let path =  Bundle.main.path(forResource: titleName, ofType: "zip"){
            let fileManager = FileManager()
        
               if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                   var destinationURL = documentsURL
                   destinationURL.appendPathComponent("directory")
                   if !isDirectoryExists(at: destinationURL) {
                       do {
                           try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                           try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL)
                           destinationURL.appendPathComponent(titleName)
                          if !isDirectoryExists(at: destinationURL) {
                              do {
                                 try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL)
                                  print("Decompression is successful, the path is:\(destinationURL.path)")
                              } catch {
                                  print("Decompression failed: \(error)")
                              }
                          }else{
                              print("The file already exists")
                          }
                          
                           print("Decompression is successful, the path is:\(destinationURL.path)")
                       } catch {
                           print("Decompression failed: \(error)")
                       }
                   } else {
                       var destinationURL2 = destinationURL
                       destinationURL2.appendPathComponent(titleName)
                       if !isDirectoryExists(at: destinationURL2) {
                           do {
                              try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL)
                              if !isDirectoryExists(at: destinationURL2){
                                 try FileManager.default.createDirectory(at: destinationURL2, withIntermediateDirectories: true, attributes: nil)
                                 try fileManager.unzipItem(at: URL(fileURLWithPath: path), to: destinationURL2)
                              }
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
        
        parseDial()
        
        
    }
    
    func parseDial(){
        let fileManager = FileManager()
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            var destinationURL = documentsURL
            destinationURL.appendPathComponent("directory/\(titleName)")
            CreekInterFace.instance.parseDial(destinationURL.path, width, height, cornerRadius,.jx3085CPlatform){ [weak self] model in
                self?.dialParseModel = model
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
                self?.setDialUI()
                
              
            }
        }
    }
    
    func setDialUI(){
        for butview in (self.view.subviews){
            if butview.isKind(of: ZBSlideColorView.self)
            {
                butview.removeFromSuperview()
            }
            if butview.isKind(of: ZBSlideBackgroundView.self)
            {
                butview.removeFromSuperview()
            }
        }
        
        var topView:UIView?
        
        if let model = dialParseModel{
            
            if(!(model.appColors ?? []).isEmpty){
                let aview = ZBSlideColorView.init(frame: CGRect.zero)
                aview.itemsTitle = model.appColors!
                aview.callback = {(index) in
                    CreekInterFace.instance.setCurrentColor(selectIndex: index) { [self]  model in
                        dispatch_main_sync_safe {
                            if let data = Data(base64Encoded: model.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
                               
                                if let image = UIImage(data: data) {
                                    aimageView.image = image
                                } else {
                                    print("Failed to create UIImage from base64 encoded string")
                                }
                            } else {
                                print("Failed to convert base64 string to Data")
                            }
                        }
                    }
                }
                self.view.addSubview(aview)
                aview.snp.makeConstraints {
                    $0.top.equalTo(aimageView.snp.bottom).offset(FBScale(20))
                    $0.height.equalTo(FBScale(300))
                    $0.left.right.equalTo(self.view)
                }
                topView = aview
            }
            
            if(!(model.backgroundImagePaths ?? []).isEmpty){
                let aview = ZBSlideBackgroundView.init(frame: CGRect.zero)
                aview.width = FBScale(CGFloat(self.width))
                aview.height = FBScale(CGFloat(self.height))
                aview.cornerRadius = FBScale(CGFloat(self.cornerRadius))
                aview.itemsTitle = model.backgroundImagePaths!
                aview.callback = {(index) in
                    CreekInterFace.instance.setCurrentBackgroundImagePath(selectIndex: index) {[self] model in
                        dispatch_main_sync_safe {
                            if let data = Data(base64Encoded: model.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
                               
                                if let image = UIImage(data: data) {
                                    aimageView.image = image
                                } else {
                                    print("Failed to create UIImage from base64 encoded string")
                                }
                            } else {
                                print("Failed to convert base64 string to Data")
                            }
                        }
                    }
                }
                self.view.addSubview(aview)
                if let bView =  topView{
                    aview.snp.makeConstraints {
                        $0.top.equalTo(bView.snp.bottom).offset(FBScale(20))
                        $0.height.equalTo(FBScale(600))
                        $0.left.right.equalTo(self.view)
                    }
                }else{
                    aview.snp.makeConstraints {
                        $0.top.equalTo(aimageView.snp.bottom).offset(FBScale(20))
                        $0.height.equalTo(FBScale(600))
                        $0.left.right.equalTo(self.view)
                    }
                }
                topView = aview
            }
            
            if(!(model.functions ?? []).isEmpty){
                let aview = CustomView()
                aview.callBlock = {
                    let sheet =  CustomSheetView(frame: CGRect(x: 0, y: 0, width: SCREENW, height: SCREENH), height: SCREENH-FBScale(200))
                    sheet.width = FBScale(CGFloat(self.width))
                    sheet.height = FBScale(CGFloat(self.height))
                    sheet.cornerRadius = FBScale(CGFloat(self.cornerRadius))
                    sheet.selectTypeBlock = { (selectIndexs)  in
                        CreekInterFace.instance.setCurrentFunction(selectIndex: selectIndexs) { model in
                            dispatch_main_sync_safe {
                                self.dialParseModel = model
                                sheet.setData(models: (model.functions ?? []))
                                if let data = Data(base64Encoded: model.previewImageBytes ?? "", options: .ignoreUnknownCharacters) {
                                   
                                    if let image = UIImage(data: data) {
                                        self.aimageView.image = image
                                    } else {
                                        print("Failed to create UIImage from base64 encoded string")
                                    }
                                } else {
                                    print("Failed to convert base64 string to Data")
                                }
                            }
                        }
                    }
                    sheet.setData(models: (self.dialParseModel?.functions!)!)
                    sheet.showSheetView()
                }
                self.view.addSubview(aview)
                if let bView =  topView{
                    aview.snp.makeConstraints {
                        $0.top.equalTo(bView.snp.bottom).offset(FBScale(20))
                        $0.width.equalTo(SCREENW)
                        $0.height.greaterThanOrEqualTo(0)
                    }
                }else{
                    aview.snp.makeConstraints {
                        $0.top.equalTo(aimageView.snp.bottom).offset(FBScale(20))
                        $0.width.equalTo(SCREENW)
                        $0.height.greaterThanOrEqualTo(0)
                    }
                }
            }
        }
    }
    
    
    func isDirectoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

}


