//
//  GlobalListenManager.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/10/8.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

class GlobalListenManager{
   
   static let shared = GlobalListenManager()
   
   var liveSportDataListenCallback: (( protocol_exercise_sync_realtime_info) -> Void)?
   var liveSportControlListenCallback: (( protocol_exercise_control_operate) -> Void)?
   var sportGpsListenCallback: ((protocol_exercise_gps_info) -> Void)?
   
   private init() {
      CreekInterFace.instance.liveSportDataListen { model in
          self.liveSportDataListenCallback?(model)
      }
      CreekInterFace.instance.liveSportControlListen { model in
          self.liveSportControlListenCallback?(model)
      }
      CreekInterFace.instance.sportGpsListen { model in
         self.sportGpsListenCallback?(model)
      }
   }
      
}

