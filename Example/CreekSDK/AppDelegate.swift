//
//  AppDelegate.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/6/27.
//

import UIKit
import BackgroundTasks
import CreekSDK
//import IQKeyboardManagerSwift



@main
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let controller = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = ExampleProvider.systemStyle()
        window?.makeKeyAndVisible()
    
//        IQKeyboardManager.shared.enable = true
        return true
    }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      print("Cut to background")
      CreekInterFace.instance.monitorPhone()
   }
    
}

