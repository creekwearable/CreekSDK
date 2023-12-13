
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif


#if os(iOS)

public let SCREENW = UIScreen.main.bounds.size.width
public let SCREENH = UIScreen.main.bounds.size.height
public let STATUSHEIGHT : CGFloat = UIApplication.shared.statusBarFrame.size.height //状态栏高度
// window 安全距离
public let SAFEAREAINSETS : UIEdgeInsets = {
    var i:UIEdgeInsets;
    let IS_IPHONE5 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
    
    let IS_IPHONE6 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
    let IS_IPHONE6_PLUS =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
    
    let window = UIApplication.shared.keyWindow;
    if #available(iOS 11.0, *) {
        if IS_IPHONE6_PLUS || IS_IPHONE5 || IS_IPHONE6{
            i = UIEdgeInsets.init(top: 20, left:0 , bottom: 0, right: 0);
        }else{
            i = (window?.safeAreaInsets)!;
        }
    }else {
        i = UIEdgeInsets.init(top: 20, left:0 , bottom: 0, right: 0);
    }
    return i;
}()


public func FBScale(_ x: CGFloat, _ Actual: CGFloat = SCREENW, _ criterion: CGFloat = 1080) -> CGFloat {
    return scaleExtent(x: x, Actual: Actual, criterion: criterion)
}

private func scaleExtent(x: CGFloat, Actual: CGFloat, criterion: CGFloat) -> CGFloat {
    return x*(Actual/criterion)
}


public func FBFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, designSize: CGFloat) -> CGRect {
    
    let myX: CGFloat = (x * SCREENW)/designSize
    let myY: CGFloat = (y * SCREENW)/designSize
    let myWidth: CGFloat = (width * SCREENW)/designSize
    let myHeight: CGFloat = (height * SCREENW)/designSize
    let rect = CGRect(x: myX, y: myY, width: myWidth, height: myHeight)
    return rect
}

//===========================

//===========================
public let INFODIC           = Bundle.main.infoDictionary

public let APPBUILDVERSION   = INFODIC?["CFBundleVersion"]
public let APPNAME           = INFODIC?["CFBundleDisplayName"]
public let VERSION           = INFODIC?["CFBundleShortVersionString"]

//===========================

//===========================
public let DEVICENAME       = UIDevice.current.name
public let SYSTEMNAME       = UIDevice.current.systemName
public let SYSTEMVERSION    = UIDevice.current.systemVersion
public let DEVICEUUID       = UIDevice.current.identifierForVendor?.uuidString
public let DEVICEMODEL      = UIDevice.current.model
#elseif os(macOS)

#endif


func dispatch_main_sync_safe(syncBlock: () -> Void) {
    if Thread.isMainThread {
        syncBlock()
    }else{
        DispatchQueue.main.sync {
            syncBlock()
        }
    }
}

func dispatch_main_async_safe(asyncBlock: @escaping () -> Void) {
    if Thread.isMainThread {
        asyncBlock()
    }else{
        DispatchQueue.main.async {
            asyncBlock()
        }
    }
}
// MARK:debug
func debugLog<T>(message: T,
    showMore: Bool = false,
    file: String = #file,
    method: String = #function,
    line: Int = #line){
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let datestr = dformatter.string(from: Date())
    print(datestr + " \(fileName)(#\(line))")
    print(message)
    #endif
}






