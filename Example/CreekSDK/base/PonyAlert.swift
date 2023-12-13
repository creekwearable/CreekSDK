// SPDX-License-Identifier: MIT
// Copyright © 2018-2019 WireGuard LLC. All Rights Reserved.

import UIKit
import MBProgressHUD
import SnapKit

public let kAdmentClickUpdateNotify = Notification.Name(rawValue: "kAdmentClickUpdateNotify")

public typealias FBAlertClickBlock = ((_ sender: String, _ controller: UIViewController) -> ())

public struct CreekAlert {
    

    public  static func alertTitle( title:String, exception:String, controller:UIViewController, cancelstr:String, buttonArr:Array<Any>,_ icon:Bool = false, clickBlock:@escaping FBAlertClickBlock)->Void{
        let alertController = UIAlertController.init(title: title, message: exception, preferredStyle: .alert)
        
        if icon == false {
            let attributedString = NSMutableAttributedString(string: exception)
            attributedString.addAttributes([
                NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: FBScale(40))!,
                NSAttributedString.Key.foregroundColor:UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: exception.count))
            alertController.setValue(attributedString, forKey: "attributedMessage")
        }else{
            let image = UIImage(named: "mac_icon_tx")
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -FBScale(8), width: FBScale(50), height: FBScale(50))
            
            let attributedString = NSMutableAttributedString(string: "")
          
            if title.count > 0{  //更新框用的
                attributedString.append(NSAttributedString(attachment: attachment))
                attributedString.append(NSAttributedString(string: " "))
                attributedString.append(NSAttributedString(string: title))
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 0
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.alignment = .center
                attributedString.addAttributes([
                    NSAttributedString.Key.paragraphStyle:paragraphStyle
                ], range: NSRange(location: 0, length: title.count))
                alertController.setValue(attributedString, forKey: "attributedTitle")
                
                let attributedString2 = NSMutableAttributedString(string: "\n")
                attributedString2.append(NSAttributedString(string: exception))
                let paragraphStyle2 = NSMutableParagraphStyle.init()
                paragraphStyle2.lineSpacing = 0
                paragraphStyle2.lineBreakMode = .byWordWrapping
                paragraphStyle2.alignment = .left
                attributedString2.addAttributes([
                    NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: FBScale(40))!,
                    NSAttributedString.Key.foregroundColor:UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphStyle2
                ], range: NSRange(location: 0, length: attributedString2.mutableString.length))
                alertController.setValue(attributedString2, forKey: "attributedMessage")
                
            }else{
                attributedString.append(NSAttributedString(attachment: attachment))
                attributedString.append(NSAttributedString(string: " "))
                attributedString.append(NSAttributedString(string: exception))
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 0
                paragraphStyle.lineBreakMode = .byWordWrapping
                paragraphStyle.alignment = .left
                attributedString.addAttributes([
                    NSAttributedString.Key.font: UIFont(name: "PingFangSC-Regular", size: FBScale(40))!,
                    NSAttributedString.Key.foregroundColor:UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1.0),NSAttributedString.Key.paragraphStyle:paragraphStyle
                ], range: NSRange(location: 2, length: exception.count))
                alertController.setValue(attributedString, forKey: "attributedMessage")
            }
            
        }
        
        for str in buttonArr {
            let alertAciton = UIAlertAction.init(title: str as? String, style: .default, handler: { (alertaction) in
                clickBlock(alertaction.title!,controller)
            })
            alertController.addAction(alertAciton)
        }
        if (cancelstr.count>0) {
            let alertAciton = UIAlertAction.init(title: cancelstr, style: .cancel, handler: { (alertaction) in
                clickBlock(alertaction.title!,controller)
            })
            alertController.addAction(alertAciton)
        }
        DispatchQueue.main.async {
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    

    public  static func alertSheetTitle ( title:String? = nil, msg:String? = nil, controller:UIViewController, cancelstr:String, buttonArr:Array<Any>, clickBlock:@escaping FBAlertClickBlock)->Void{
        dispatch_main_sync_safe {
            let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .actionSheet)
            
            for str in buttonArr {
                let alertAciton = UIAlertAction.init(title: str as? String, style: .`default`, handler: { (alertaction) in
                    clickBlock(alertaction.title!,controller)
                })
                let imageview = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageview.image = UIImage.init(named: "mac_icon_tx")
                alertController.addAction(alertAciton)
                alertController.view.addSubview(imageview)
            }
            if (cancelstr.count>0) {
                let alertAciton = UIAlertAction.init(title: cancelstr, style: .cancel, handler: { (alertaction) in
                    clickBlock(alertaction.title!,controller)
                })
                alertController.addAction(alertAciton)
            }
            controller.present(alertController, animated: true, completion: nil)
        }
        
    }
    public  static func DataConversion(index:Int) -> String {
        
        var str : String = ""
        if index >= 10000 {
            str = String(format: "%.1fW", Double(index)/10000)
        }else{
            str = String(format: "%d", index)
        }
        return str
    }
    
    
    

    public  static func alertMsg(exception:String){
        dispatch_main_sync_safe {
            let aview = UIApplication.shared.keyWindow
            let hud = MBProgressHUD.showAdded(to: aview!, animated: true)
            hud.contentColor = UIColor.white
            hud.bezelView.style = .solidColor;
            hud.bezelView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            hud.detailsLabel.text = exception;
            hud.detailsLabel.font = UIFont(name: "PingFangSC-Regular", size: FBScale(42))!
            hud.mode = .customView;
            hud.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(0)
                $0.left.right.bottom.equalTo(aview!)
            }
            hud.hide(animated: true, afterDelay: 2)
        }
    }
    
}


@available(iOS 8.0, *)
public enum RemarkStyle : Int {
    
    case msgloading
    
    case loading
    
    case nodata
    
    case nodata1
    
    case nonetwork
}

public typealias RemarkBlock = (() -> ())

extension UIView {
    
    public  func showRemark(msg:String , remarkType:RemarkStyle){
        
        var imagename = ""
        
        switch remarkType {
        case .loading:
            imagename = "loading_all.gif"
            break
        case .nodata:
            imagename = "shujukongbai_03"
            break
        case .nodata1:
            imagename = "shujukongbai_02"
            break
        case .nonetwork:
            imagename = "VerificationCode.gif"
            break
        case .msgloading:
            imagename = "VerificationCode.gif"
            
        }
        
        self.showRemark(msg: msg, imageName: imagename)
    }
    
    public  func showRemark(msg:String , imageName:String){
        
    }
    
    
    public  func showRemark(msg:String){
        dispatch_main_sync_safe {
            self.hideRemark()
            let hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.label.text = msg
        }
    }
    

    public  func hideRemark() {
        dispatch_main_sync_safe {
            MBProgressHUD.hide(for: self, animated: true)
        }
        
    }
    
}

