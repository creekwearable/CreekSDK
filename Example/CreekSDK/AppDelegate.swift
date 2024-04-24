//
//  AppDelegate.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/6/27.
//

import UIKit
import BackgroundTasks
import CreekSDK



@main
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let controller = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = ExampleProvider.systemStyle()
        window?.makeKeyAndVisible()
        CreekInterFace.instance.setupInit()
        CreekInterFace.instance.initSDK()
       
       let keyId = "*********"
       let publicKey = "***********"
        
        CreekInterFace.instance.ephemerisInit(keyId: keyId, publicKey: publicKey) {
            ///Ask for GPS data, and get the latest GPS data every time you ask.
            let model = EphemerisGPSModel()
            model.altitude = 10
            model.latitude = Int(22.312653 * 1000000)
            model.longitude = Int(114.027986 * 1000000)
            model.isVaild = true
            return model
         
        }
        return true
    }
    
    
    

    

    
}

