//
//  CreekSDKExtension.swift
//  CreekSDK
//
//  Created by bean on 2023/7/15.
//

import Foundation
import Contacts

extension CreekSDK{
   
   ///MARK : initialization SDK
   public func initSDK(type:CreekClientType = .none,cancelAutoConnect:CancelAutoConnectType = .auto) {
      methodChannel?.invokeMethod("initSDK", arguments: [type.rawValue,cancelAutoConnect.rawValue])
   }
   
   ///MARK : Authorization code verification
   /// - Parameter :
   ///     -type : 1 verify  0 none
   /// - Returns:
   public func authorization(type:Int) {
      methodChannel?.invokeMethod("authorization", arguments: type)
   }
   
   ///MARK : automatic connection
   /// - Parameter :
   ///     -type : 1 Supported  0 cancel
   /// - Returns:
   public func autoConnect(type:Int) {
      methodChannel?.invokeMethod("autoConnect", arguments: type)
   }
   
   ///MARK : Bluetooth scan
   /// - Parameter :
   ///      - timeOut :  automatically stops the scan after a specified
   ///      - devices :  Returned device information  [ScanDeviceModel]
   ///      - endScan : A callback at the end of the scan
   /// - Returns:
   public func scan(timeOut:Int = 15,devices:@escaping devicesBack,endScan:@escaping endScanBase) {
      serialQueue.sync {
         requestId+=1
         devicesBackDic["scanBase\(requestId)"] = devices
         endScanDic["endScan\(requestId)"] = endScan
         methodChannel?.invokeMethod("scanBase\(requestId)", arguments: timeOut)
      }
   }
   ///MARK : connect
   /// - Parameter :
   ///      - id :  DeviceModel.id
   ///      - connect :   call back connect state   true false
   /// - Returns:
   public func connect(id:String,connect:@escaping ((_ connectState:Bool)->())) {
      _connect = connect
      methodChannel?.invokeMethod("connect", arguments: id)
   }
   
   public func externalConnect(id:String,connect:@escaping ((_ connectState:Bool)->())) {
      _connect = connect
      methodChannel?.invokeMethod("externalConnect", arguments: id)
   }
   
   ///MARK : connect
   /// - Parameter :
   ///      - id :  DeviceModel.id
   ///      - connect :   call back connect state   true false
   /// - Returns:
   public func scanConnect(id:String,device:@escaping deviceBack,failure:@escaping failureArgument) {
      serialQueue.sync{
         requestId+=1
         deviceBackDic["scanConnect\(requestId)"] = device
         failureArgumentDic["scanConnect\(requestId)"] = failure
         methodChannel?.invokeMethod("scanConnect\(requestId)", arguments: id)
      }
   }
   
   ///MARK : connect
   /// - Parameter :
   ///      - id :  DeviceModel.id
   ///      - connect :   call back connect state   true false
   /// - Returns:
   public func inTransitionDevice(id:String,inTransitionDevice:@escaping ((_ connectState:Bool)->())) {
      _inTransitionDevice = inTransitionDevice
      methodChannel?.invokeMethod("inTransitionDevice", arguments: id)
   }
   
   ///MARK : disconnect
   public func disconnect(success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync{
         requestId+=1
         successDic["disconnect\(requestId)"] = success;
         failureArgumentDic["disconnect\(requestId)"] = failure
         methodChannel?.invokeMethod("disconnect\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK : Stop scanning
   @objc public func stopScan() {
      methodChannel?.invokeMethod("stopScan", arguments: "")
   }
   ///MARK :Get Firmware Information
   /// - Parameter :
   ///      - model: call back protocol_device_info
   ///      - failure: (code: error code message: content)
   /// - Returns:
   public func getFirmware(model:@escaping firmwareBase,failure:@escaping failureArgument) {
      requestId+=1
      var firmwareDicCopy = firmwareDic
      firmwareDicCopy["getFirmware\(requestId)"] = model
      firmwareDic = firmwareDicCopy
      var failureArgumentDicCopy = failureArgumentDic
      failureArgumentDicCopy["getFirmware\(requestId)"] = failure
      failureArgumentDic = failureArgumentDicCopy
      methodChannel?.invokeMethod("getFirmware\(requestId)", arguments: "")
   }
   public func getSNFirmware(model:protocol_device_info,sn:@escaping SNFirmwareBase) {
      serialQueue.sync{
         requestId+=1
         SNFirmwareDic["getSNFirmware\(requestId)"] = sn
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("getSNFirmware\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   ///MARK :Sync health data
   /// - Parameter :
   ///      - syncProgress: sync progress
   /// - Returns:
   public func sync(syncProgress:@escaping progressBase, syncSuccess:@escaping successBase, syncFailure:@escaping failureBase) {
      serialQueue.sync {
         requestId+=1
         progressDic["syncBase\(requestId)"] = syncProgress
         successDic["syncBase\(requestId)"] = syncSuccess;
         failureDic["syncBase\(requestId)"] = syncFailure
         methodChannel?.invokeMethod("syncBase\(requestId)", arguments: "")
      }
      
   }
   ///MARK :upload
   /// - Parameter :
   ///      - fileName：The filename needs to include the suffix
   ///    .ota Airlift firmware file
   ///    .log Firmware log file
   ///    .rawdata sensor raw data file
   ///    .phone phone book
   ///    .pcm mic voice file
   ///    .bin watch face file
   ///    .agnss offline ephemeris file
   ///    .gnss online ephemeris file
   ///      - fileData :  File Data
   ///      - uploadProgress：upload progress
   ///
   /// - Returns:
   public func upload(fileName:String,fileData:Data,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         progressDic["upload\(requestId)"] = uploadProgress
         successDic["upload\(requestId)"] = uploadSuccess;
         failureArgumentDic["upload\(requestId)"] = uploadFailure
         var intArray: [Int] = []
         fileData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let buffer = UnsafeBufferPointer(start: bytes, count: fileData.count)
            intArray = Array(buffer).map { Int($0) }
         }
         let dic:[String:Any] = ["fileName":fileName,"fileData":intArray]
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("upload\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
   }
   
   public func uploadWithFilePath(fileName:String,filePath:String,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         progressDic["filePathWithUpload\(requestId)"] = uploadProgress
         successDic["filePathWithUpload\(requestId)"] = uploadSuccess;
         failureArgumentDic["filePathWithUpload\(requestId)"] = uploadFailure
         let dic:[String:Any] = ["fileName":fileName,"filePath":filePath]
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("filePathWithUpload\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
      
   }
   
   ///MARK :backstageUpload
   /// - Parameter :
   ///      - fileName：The filename needs to include the suffix
   ///    .ota Airlift firmware file
   ///    .log Firmware log file
   ///    .rawdata sensor raw data file
   ///    .phone phone book
   ///    .pcm mic voice file
   ///    .bin watch face file
   ///    .agnss offline ephemeris file
   ///    .gnss online ephemeris file
   ///      - fileData :  File Data
   ///      - uploadProgress：upload progress
   ///
   /// - Returns:
   public func backstageUpload(fileName:String,fileData:Data,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         progressDic["backstageUpload\(requestId)"] = uploadProgress
         successDic["backstageUpload\(requestId)"] = uploadSuccess;
         failureArgumentDic["backstageUpload\(requestId)"] = uploadFailure
         var intArray: [Int] = []
         fileData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let buffer = UnsafeBufferPointer(start: bytes, count: fileData.count)
            intArray = Array(buffer).map { Int($0) }
         }
         
         let dic:[String:Any] = ["fileName":fileName,"fileData":intArray]
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("backstageUpload\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
      
   }
   
   ///MARK :Monitor the status of connected devices
   /// - Parameter :
   ///      - listenDeviceState：
   /// - Returns:
   public func listenDeviceState(listenDeviceState:@escaping (_ status:connectionStatus,_ deviceName:String)->()) {
      _listenDeviceState = listenDeviceState
   }
   
   ///MARK :Monitor the status of connected devices
   /// - Parameter :
   ///      - listenDeviceState：
   /// - Returns:
   public func listenMultipleDeviceState(listenID:String,listenDeviceState:@escaping listenDeviceBase) {
      listenDeviceClosureDic[listenID] = listenDeviceState
   }
   
   ///MARK :Monitor the status of connected devices
   /// - Parameter :
   ///      - listenDeviceState：
   /// - Returns:
   public func removeListenMultipleDeviceState(listenID:String) {
      if let _ = listenDeviceClosureDic[listenID]{
         listenDeviceClosureDic.removeValue(forKey: listenID)
      }
   }
   
   
   ///MARK :Device bluetooth status
   /// - Parameter :
   ///      - model: call back protocol_connect_status_inquire_reply
   /// - Returns:
   public func bluetoothStatus(model:@escaping bluetoothStatusBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         bluetoothStatusDic["bluetoothStatus\(requestId)"] = model
         failureArgumentDic["bluetoothStatus\(requestId)"] = failure
         methodChannel?.invokeMethod("bluetoothStatus\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :retrigger bt connect
   /// - Parameter :
   ///      - reconnect ： true false
   /// - Returns:
   public func firmwareReconnect(reconnect:Bool,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["firmwareReconnect\(requestId)"] = success;
         failureArgumentDic["firmwareReconnect\(requestId)"] = failure
         var model =  protocol_connect_status_operate()
         model.reconnectOperate = reconnect
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("firmwareReconnect\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   ///MARK :Synchronize phone time to firmware
   public func syncTime(success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["syncTime\(requestId)"] = success;
         failureArgumentDic["syncTime\(requestId)"] = failure
         methodChannel?.invokeMethod("syncTime\(requestId)", arguments: "")
      }
      
      
   }
   ///MARK :Get firmware time
   /// - Parameter :
   ///      - model：call back protocol_device_time_inquire_reply
   /// - Returns:
   public func getTime(model:@escaping timeBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         timeDic["getTime\(requestId)"] = model
         failureArgumentDic["getTime\(requestId)"] = failure
         methodChannel?.invokeMethod("getTime\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :get Language
   /// - Parameter :
   ///      - model：call back protocol_language_inquire_reply
   /// - Returns:
   public func getLanguage(model:@escaping languageBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         languageDic["getLanguage\(requestId)"] = model
         failureArgumentDic["getLanguage\(requestId)"] = failure
         methodChannel?.invokeMethod("getLanguage\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK : set Language
   /// - Parameter :
   ///      - type：language
   /// - Returns:
   public func setLanguage(type:language,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         var model = protocol_language_operate()
         model.curLanguage = type
         successDic["setLanguage\(requestId)"] = success;
         failureArgumentDic["setLanguage\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setLanguage\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK : bind device
   /// - Parameter :
   ///      - bindType：
   ///                 BindType.bindeNcrypted     address-> nil  code-> nil
   ///                 BindType.binNormal      address-> nil  code-> nil
   ///                 BindType.bindRemove   address-> DeviceModel.id  code-> nil
   ///                 BindType.bindPairingCode   address-> nil  code-> nil    get pairing code
   ///                 BindType.bindPairingCode   address-> nil  code-> 1234    Pair code verification
   ///       -id: DeviceModel.id
   ///       -code:pairing code
   /// - Returns:LanguageModel
   public func bindingDevice(bindType:BindType,id:String?,code:String?,saveDate:Bool = false,success:@escaping successBase,failure:@escaping failureBase) {
      serialQueue.sync {
         requestId+=1
         successDic["bindDevice\(requestId)"] = success;
         failureDic["bindDevice\(requestId)"] = failure
         
         let dic:[String:Any?] = ["bindType":bindType.rawValue,"address":id,"pairCode":code,"saveDate":saveDate ? 1 : 0]
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("bindDevice\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
      
   }
   
   
   public func authorizationVerificationDevice(success:@escaping successBase,failure:@escaping failureBase,authorizationFailure:@escaping authorizationFailureBase) {
      serialQueue.sync {
         requestId+=1
         successDic["authorizationVerificationDevice\(requestId)"] = success
         failureDic["authorizationVerificationDevice\(requestId)"] = failure
         authorizationFailureDic["authorizationVerificationDevice\(requestId)"] = authorizationFailure
         methodChannel?.invokeMethod("authorizationVerificationDevice\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Get firmware user information and preferences
   /// - Parameter :
   ///      - model：call back protocol_user_info_operate
   /// - Returns:
   public func getUserInfo(model:@escaping userBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         userDic["getUserInfo\(requestId)"] = model
         failureArgumentDic["getUserInfo\(requestId)"] = failure
         methodChannel?.invokeMethod("getUserInfo\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Set firmware user information and preferences
   /// - Parameter :
   ///      - model: protocol_user_info_operate
   /// - Returns:
   public func setUserInfo(model:protocol_user_info_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setUserInfo\(requestId)"] = success;
         failureArgumentDic["setUserInfo\(requestId)"] = failure
         do{
            var operate =  protocol_user_info_inquire_reply()
            operate.goalSetting = model.goalSetting
            operate.personalInfo = model.personalInfo
            operate.perferences = model.perferences
            let data = try operate.serializedData()
            //            let intArray = data!.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> [Int] in
            //                let buffer = UnsafeBufferPointer(start: pointer, count: data!.count)
            //                return Array(buffer.map({ Int($0) }))
            //            }
            //            print(intArray)
            methodChannel?.invokeMethod("setUserInfo\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Get an alarm clock
   /// - Parameter :
   ///      - model：call back protocol_alarm_inquire_reply
   /// - Returns:
   public func getAlarm(model:@escaping alarmBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         alarmDic["getAlarm\(requestId)"] = model
         failureArgumentDic["getAlarm\(requestId)"] = failure
         methodChannel?.invokeMethod("getAlarm\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :set an alarm
   /// - Parameter :
   ///      - model ：protocol_alarm_operate
   /// - Returns:
   public func setAlarm(model:protocol_alarm_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setAlarm\(requestId)"] = success;
         failureArgumentDic["setAlarm\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setAlarm\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Get do not disturb
   /// - Parameter :
   ///      - model：call back protocol_disturb_inquire_reply
   /// - Returns:protocol_alarm_inquire_reply
   public func getDisturb(model:@escaping disturbBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         disturbDic["getDisturb\(requestId)"] = model
         failureArgumentDic["getDisturb\(requestId)"] = failure
         methodChannel?.invokeMethod("getDisturb\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Set do not disturb
   /// - Parameter :
   ///      - model: protocol_disturb_operate
   /// - Returns:
   public func setDisturb(model:protocol_disturb_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setDisturb\(requestId)"] = success;
         failureArgumentDic["setDisturb\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setDisturb\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   
   ///MARK :Get focus mode
   /// - Parameter :
   ///      - model：call back protocol_focus_mode_inquire_reply
   /// - Returns:protocol_alarm_inquire_reply
   public func getFocusSleep(model:@escaping focusBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         focusDic["getFocus\(requestId)"] = model
         failureArgumentDic["getFocus\(requestId)"] = failure
         methodChannel?.invokeMethod("getFocus\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Set focus mode
   /// - Parameter :
   ///      - model: protocol_focus_mode_operate
   /// - Returns:
   public func setFocusSleep(model:protocol_focus_mode_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setFocus\(requestId)"] = success;
         failureArgumentDic["setFocus\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setFocus\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Get app List
   /// - Parameter :
   ///      - model：call back protocol_app_list_inquire_reply
   /// - Returns:protocol_app_list_inquire_reply
   public func getAppList(model:@escaping appListBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         appListDic["getAppList\(requestId)"] = model
         failureArgumentDic["getAppList\(requestId)"] = failure
         methodChannel?.invokeMethod("getAppList\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Set app List
   /// - Parameter :
   ///      - model: protocol_app_list_operate
   /// - Returns:
   public func setAppList(model:protocol_app_list_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setAppList\(requestId)"] = success;
         failureArgumentDic["setAppList\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setAppList\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :EventTracking
   /// - Parameter :
   ///      - model：call back protocol_event_tracking_inquire_reply
   /// - Returns:protocol_event_tracking_inquire_reply
   public func getEventTracking(model:@escaping eventTrackingBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         eventTrackingDic["getEventTracking\(requestId)"] = model
         failureArgumentDic["getEventTracking\(requestId)"] = failure
         methodChannel?.invokeMethod("getEventTracking\(requestId)", arguments: "")
      }
      
   }
   
   
   
   
   ///MARK :Get screen brightness
   /// - Parameter :
   ///      - model:call back protocol_screen_brightness_inquire_reply
   /// - Returns:
   public func getScreen(model:@escaping screenBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         screenDic["getScreen\(requestId)"] = model
         failureArgumentDic["getScreen\(requestId)"] = failure
         methodChannel?.invokeMethod("getScreen\(requestId)", arguments: "")
      }
      
   }
   
   ///MARK :Screen Brightness Settings
   /// - Parameter :
   ///      - model: protocol_screen_brightness_operate
   /// - Returns:
   public func setScreen(model:protocol_screen_brightness_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setScreen\(requestId)"] = success;
         failureArgumentDic["setScreen\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setScreen\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Health Monitoring Acquisition
   /// - Parameter :
   ///      - operate: protocol_health_monitor_operate
   ///      - model : call back protocol_health_monitor_inquire_reply
   /// - Returns:
   public func getMonitor(operate:protocol_health_monitor_operate,model:@escaping monitorBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         monitorDic["getMonitor\(requestId)"] = model
         failureArgumentDic["getMonitor\(requestId)"] = failure
         do{
            let data = try operate.serializedData()
            methodChannel?.invokeMethod("getMonitor\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
      
   }
   
   ///MARK :Health Monitoring Settings
   /// - Parameter :
   ///      - model :protocol_health_monitor_operate
   /// - Returns:
   public func setMonitor(model:protocol_health_monitor_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setMonitor\(requestId)"] = success;
         failureArgumentDic["setMonitor\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMonitor\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Sleep Monitoring Acquisition
   /// - Parameter :
   ///      - model: protocol_sleep_monitor_inquire_reply
   /// - Returns:
   public func getSleepMonitor(model:@escaping sleepMonitorBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sleepMonitorDic["getSleepMonitor\(requestId)"] = model
         failureArgumentDic["getSleepMonitor\(requestId)"] = failure
         methodChannel?.invokeMethod("getSleepMonitor\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Sleep Monitoring Settings
   /// - Parameter :
   ///      - model：protocol_sleep_monitor_operate
   /// - Returns:
   public func setSleepMonitor(model:protocol_sleep_monitor_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSleepMonitor\(requestId)"] = success;
         failureArgumentDic["setSleepMonitor\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSleepMonitor\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :drink water reminder
   /// - Parameter :
   ///      - model：protocol_drink_water_inquire_reply
   /// - Returns:
   public func getWater(model:@escaping waterBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         waterDic["getWater\(requestId)"] = model
         failureArgumentDic["getWater\(requestId)"] = failure
         methodChannel?.invokeMethod("getWater\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK ::drink water Settings
   /// - Parameter :
   ///      - model:protocol_drink_water_operate
   /// - Returns:
   public func setWater(model:protocol_drink_water_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setWater\(requestId)"] = success;
         failureArgumentDic["setWater\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWater\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   
   public func getFindPhoneWatch(model:@escaping findPhoneWatchBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         findPhoneWatchDic["getFindPhoneWatch\(requestId)"] = model
         failureArgumentDic["getFindPhoneWatch\(requestId)"] = failure
         methodChannel?.invokeMethod("getFindPhoneWatch\(requestId)", arguments: "")
      }
      
   }
   
   
   public func setFindPhoneWatch(model:protocol_find_phone_watch_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setFindPhoneWatch\(requestId)"] = success;
         failureArgumentDic["setFindPhoneWatch\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setFindPhoneWatch\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   public func setStopPhone(success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setStopPhone\(requestId)"] = success;
         failureArgumentDic["setStopPhone\(requestId)"] = failure
         methodChannel?.invokeMethod("setStopPhone\(requestId)", arguments: "")
      }
      
   }
   
   
   //    public func getVoice(model:@escaping ((_ model:protocol_voice_assistant_inquire_reply) -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        voice = model
   //        failureArgumentDic["getVoice"] = failure
   //        methodChannel?.invokeMethod("getVoice", arguments: "")
   //
   //    }
   //
   //    public func setVoice(model:protocol_voice_assistant_operate,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        successDic["setVoice"] = success;
   //        failureArgumentDic["setVoice"] = failure
   //        do{
   //            let data = try model.serializedData()
   //            methodChannel?.invokeMethod("setVoice", arguments: data)
   //        }catch{
   //
   //        }
   //    }
   
   ///MARK :World Clock Fetch
   /// - Parameter :
   ///      - model: protocol_world_time_inquire_reply
   /// - Returns:
   public func getWorldTime(model:@escaping worldTimeBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         worldTimeDic["getWorldTime\(requestId)"] = model
         failureArgumentDic["getWorldTime\(requestId)"] = failure
         methodChannel?.invokeMethod("getWorldTime\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :world clock setting
   /// - Parameter :
   ///      - model ：protocol_world_time_operate
   /// - Returns:
   public func setWorldTime(model:protocol_world_time_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setWorldTime\(requestId)"] = success;
         failureArgumentDic["setWorldTime\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWorldTime\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   public func getStanding(model:@escaping standingBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         standingDic["getStanding\(requestId)"] = model
         failureArgumentDic["getStanding\(requestId)"] = failure
         methodChannel?.invokeMethod("getStanding\(requestId)", arguments: "")
      }
      
      
      
   }
   public func setStanding(model:protocol_standing_remind_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setStanding\(requestId)"] = success;
         failureArgumentDic["setStanding\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setStanding\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
      
   }
   
   
   //    public func getMessageType(model:@escaping ((_ model:protocol_message_notify_func_support_reply) -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        messageType = model
   //        failureArgumentDic["getMessageType"] = failure
   //        methodChannel?.invokeMethod("getMessageType", arguments: "")
   //
   //    }
   
   
   //    public func getMessageApp(model:@escaping ((_ model:protocol_message_notify_data_inquire_reply) -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        messageApp = model
   //        failureArgumentDic["getMessageApp"] = failure
   //        methodChannel?.invokeMethod("getMessageApp", arguments: "")
   //
   //    }
   
   
   //    public func setMessageApp(model:protocol_message_notify_data,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        successDic["setMessageApp"] = success;
   //        failureArgumentDic["setMessageApp"] = failure
   //        do{
   //            let data = try model.serializedData()
   //            methodChannel?.invokeMethod("setMessageApp", arguments: data)
   //        }catch{
   //
   //        }
   //    }
   
   ///MARK :Get message switch
   /// - Parameter :
   ///      - model: protocol_message_notify_switch_inquire_reply
   /// - Returns:
   public func getMessageOnOff(model:@escaping messageOnOffBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         messageOnOffDic["getMessageOnOff\(requestId)"] = model
         failureArgumentDic["getMessageOnOff\(requestId)"] = failure
         methodChannel?.invokeMethod("getMessageOnOff\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :message switch settings
   /// - Parameter :
   ///      - model ：protocol_message_notify_switch
   /// - Returns:
   public func setMessageOnOff(model:protocol_message_notify_switch,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setMessageOnOff\(requestId)"] = success;
         failureArgumentDic["setMessageOnOff\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMessageOnOff\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :music control
   /// - Parameter :
   ///      - model ：protocol_music_control_operate
   /// - Returns:
   public func setMusic(model:protocol_music_control_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setMusic\(requestId)"] = success;
         failureArgumentDic["setMusic\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMusic\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :set weather
   /// - Parameter :
   ///      - model: protocol_weather_operate
   /// - Returns:
   public func setWeather(model:protocol_weather_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setWeather\(requestId)"] = success;
         failureArgumentDic["setWeather\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWeather\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   
   ///MARK :Incoming call configuration query
   /// - Parameter :
   ///      - model : call back protocol_call_switch_inquire_reply
   /// - Returns:protocol_alarm_inquire_reply
   public func getCall(model:@escaping callBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         callDic["getCall\(requestId)"] = model
         failureArgumentDic["getCall\(requestId)"] = failure
         methodChannel?.invokeMethod("getCall\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :caller configuration settings
   /// - Parameter :
   ///      - model : protocol_call_switch
   /// - Returns:
   public func setCall(model:protocol_call_switch,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setCall\(requestId)"] = success;
         failureArgumentDic["setCall\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setCall\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   
   //    public func setCallReminder(model:protocol_call_remind,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        successDic["setCallReminder"] = success;
   //        failureArgumentDic["setCallReminder"] = failure
   //        do{
   //            let data = try model.serializedData()
   //            methodChannel?.invokeMethod("setCallReminder", arguments: data)
   //        }catch{
   //
   //        }
   //    }
   
   
   //    public func setCallState(model:protocol_call_remind_status,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
   //        successDic["setCallState"] = success;
   //        failureArgumentDic["setCallState"] = failure
   //        do{
   //            let data = try model.serializedData()
   //            methodChannel?.invokeMethod("setCallState", arguments: data)
   //        }catch{
   //
   //        }
   //    }
   //
   ///MARK :contact acquisition
   /// - Parameter :
   ///      - model ：protocol_frequent_contacts_inquire_reply
   /// - Returns:
   public func getContacts(model:@escaping contactsBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         contactsDic["getContacts\(requestId)"] = model
         failureArgumentDic["getContacts\(requestId)"] = failure
         methodChannel?.invokeMethod("getContacts\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :contact settings
   /// - Parameter :
   ///      - model ：protocol_frequent_contacts_operate
   /// - Returns:
   public func setContacts(model:protocol_frequent_contacts_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setContacts\(requestId)"] = success;
         failureArgumentDic["setContacts\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setContacts\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Get quick card
   /// - Parameter :
   /// - Returns:
   public func getCard(model:@escaping cardBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         cardDic["getCard\(requestId)"] = model
         failureArgumentDic["getCard\(requestId)"] = failure
         methodChannel?.invokeMethod("getCard\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Set up quick cards
   /// - Parameter :
   ///           -model : protocol_quick_card_operate
   /// - Returns:
   public func setCard(model:protocol_quick_card_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setCard\(requestId)"] = success;
         failureArgumentDic["setCard\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setCard\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Set do not disturb
   /// - Parameter :
   ///      - protocol_exercise_heart_rate_zone
   /// - Returns:
   public func setSportHeartRate(model:protocol_exercise_heart_rate_zone,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSportHeartRate\(requestId)"] = success;
         failureArgumentDic["setSportHeartRate\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportHeartRate\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Obtain the type of movement supported by the device
   /// - Parameter :
   ///      - model ：protocol_exercise_sporting_param_sort_inquire_reply
   /// - Returns:
   public func getSportType(model:@escaping sportTypeBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sportTypeDic["getSportType\(requestId)"] = model
         failureArgumentDic["getSportType\(requestId)"] = failure
         methodChannel?.invokeMethod("getSportType\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Equipment motion arrangement order setting
   /// - Parameter :
   ///      - model ：protocol_exercise_sport_mode_sort
   /// - Returns:
   public func setSportSort(model:protocol_exercise_sport_mode_sort,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSportSort\(requestId)"] = success;
         failureArgumentDic["setSportSort\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportSort\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Query the sequence of equipment movement
   /// - Parameter :
   ///      - model ： call back protocol_exercise_sport_mode_sort_inquire_reply
   /// - Returns:protocol_alarm_inquire_reply
   public func getSportSort(model:@escaping sportSortBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sportSortDic["getSportSort\(requestId)"] = model
         failureArgumentDic["getSportSort\(requestId)"] = failure
         methodChannel?.invokeMethod("getSportSort\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Child item data setting in sports
   /// - Parameter :
   ///      - model: protocol_exercise_sporting_param_sort
   /// - Returns:
   public func setSportSub(model:protocol_exercise_sporting_param_sort,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSportSub\(requestId)"] = success;
         failureArgumentDic["setSportSub\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportSub\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Data acquisition of children in sports
   /// - Parameter :
   ///      - model：call back protocol_exercise_sporting_param_sort_inquire_reply
   /// - Returns:protocol_alarm_inquire_reply
   public func getSportSub(model:@escaping sportSubBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sportSubDic["getSportSub\(requestId)"] = model
         failureArgumentDic["getSportSub\(requestId)"] = failure
         methodChannel?.invokeMethod("getSportSub\(requestId)", arguments: "")
      }
      
      
   }
   
   
   ///MARK :Sports self-recognition settings
   /// - Parameter :
   ///      - model : protocol_exercise_intelligent_recognition
   /// - Returns:
   public func setSportIdentification(model:protocol_exercise_intelligent_recognition,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSportIdentification\(requestId)"] = success;
         failureArgumentDic["setSportIdentification\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportIdentification\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Sports self-identification query
   /// - Parameter :
   ///      - model : call back protocol_exercise_intelligent_recognition_inquire_reply
   /// - Returns:
   public func getSportIdentification(model:@escaping sportIdentificationBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sportIdentificationDic["getSportIdentification\(requestId)"] = model
         failureArgumentDic["getSportIdentification\(requestId)"] = failure
         methodChannel?.invokeMethod("getSportIdentification\(requestId)", arguments: "")
      }
      
      
   }
   
   
   ///MARK :set dial
   /// - Parameter :
   ///      - model : protocol_watch_dial_plate_operate
   /// - Returns:
   public func setWatchDial(model:protocol_watch_dial_plate_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setWatchDial\(requestId)"] = success;
         failureArgumentDic["setWatchDial\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWatchDial\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Remove dial
   /// - Parameter :
   ///      - model : protocol_watch_dial_plate_operate
   /// - Returns:
   public func delWatchDial(model:protocol_watch_dial_plate_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["delWatchDial\(requestId)"] = success;
         failureArgumentDic["delWatchDial\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("delWatchDial\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Query dial
   /// - Parameter :
   ///      - model : call back protocol_watch_dial_plate_operate
   /// - Returns:
   public func getWatchDial(model:@escaping watchDialBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         watchDialDic["getWatchDial\(requestId)"] = model
         failureArgumentDic["getWatchDial\(requestId)"] = failure
         methodChannel?.invokeMethod("getWatchDial\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :setSystem Settings
   /// - Parameter :
   ///      - type ：1 Restart operation 2 Shut down operation  3 Restore factory settings  4 Clear bt information
   /// - Returns:
   public func setSystem(type:Int,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSystem\(requestId)"] = success;
         failureArgumentDic["setSystem\(requestId)"] = failure
         methodChannel?.invokeMethod("setSystem\(requestId)", arguments: type)
      }
      
   }
   
   
   ///MARK :Get quick card
   /// - Parameter :
   /// - Returns:
   public func getHotKey(model:@escaping hotKeyBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         hotKeyDic["getHotKey\(requestId)"] = model
         failureArgumentDic["getHotKey\(requestId)"] = failure
         methodChannel?.invokeMethod("getHotKey\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Set up quick cards
   /// - Parameter :
   ///           -model : protocol_quick_card_operate
   /// - Returns:
   public func setHotKey(model:protocol_button_crown_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setHotKey\(requestId)"] = success;
         failureArgumentDic["setHotKey\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setHotKey\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   ///MARK :Get menu
   /// - Parameter :
   /// - Returns:
   public func getTable(model:@escaping tableBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         tableDic["getTable\(requestId)"] = model
         failureArgumentDic["getTable\(requestId)"] = failure
         methodChannel?.invokeMethod("getTable\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Get emergency contacts
   /// - Parameter :
   /// - Returns:
   public func getContactsSOS(model:@escaping sosContactsBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         sosContactsDic["getSOSContacts\(requestId)"] = model
         failureArgumentDic["getSOSContacts\(requestId)"] = failure
         methodChannel?.invokeMethod("getSOSContacts\(requestId)", arguments: "")
      }
      
      
   }
   
   ///MARK :Emergency contact settings
   /// - Parameter :
   ///           -model : protocol_emergency_contacts_operate
   /// - Returns:
   public func setContactsSOS(model:protocol_emergency_contacts_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSOSContacts\(requestId)"] = success;
         failureArgumentDic["setSOSContacts\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSOSContacts\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   public func getMenstrual(model:@escaping menstrualBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         menstrualDic["getMenstrual\(requestId)"] = model
         failureArgumentDic["getMenstrual\(requestId)"] = failure
         methodChannel?.invokeMethod("getMenstrual\(requestId)", arguments: "")
      }
      
   }
   
   
   public func setMenstrual(model:protocol_menstruation_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setMenstrual\(requestId)"] = success;
         failureArgumentDic["setMenstrual\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMenstrual\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   
   public func noticeUpdateListen(noticeUpdateListen:@escaping (_ model:NoticeUpdateModel) -> ()) {
      _noticeUpdateListen = noticeUpdateListen
   }
   
   public func eventReportListen(eventReportListen:@escaping (_ model:EventReportModel) -> ()) {
      _eventReportListen = eventReportListen
   }
   
   public func exceptionListen(exceptionListen:@escaping (_ model:String) -> ()) {
      _exceptionListen = exceptionListen
   }
   
   
   
   
   
   
   
   
   
   ///MARK :Get Active Health Data
   /// - Parameter :
   ///      - startTime 2023-08-03
   ///      - endTime 2023-08-03
   /// - Returns:
   public func getActivityNewTimeData(startTime:String,endTime:String,model: @escaping activitysClosure) {
      serialQueue.sync {
         requestId+=1
         activitysClosureDic["getActivityNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getActivityNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   
   ///MARK :Get Sleep Health Data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getSleepNewTimeData(startTime:String,endTime:String,model:@escaping sleepsClosure) {
      serialQueue.sync {
         requestId+=1
         sleepsClosureDic["getSleepNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getSleepNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   ///MARK :Get Heart Rate Health Data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getHeartRateNewTimeData(startTime:String,endTime:String,model:@escaping heartRatesClosure) {
      serialQueue.sync {
         requestId+=1
         heartRatesClosureDic["getHeartRateNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getHeartRateNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   ///MARK :Get Stress Health Data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getStressNewTimeData(startTime:String,endTime:String,model:@escaping stresssClosure) {
      serialQueue.sync {
         requestId+=1
         stresssClosureDic["getStressNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getStressNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   ///MARK :Get Noise Health Data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getNoiseNewTimeData(startTime:String,endTime:String,model:@escaping noisesClosure) {
      serialQueue.sync {
         requestId+=1
         noisesClosureDic["getNoiseNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getNoiseNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   ///MARK :Obtain blood oxygen health data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getSpoNewTimeData(startTime:String,endTime:String,model:@escaping oxygensClosure) {
      serialQueue.sync {
         requestId+=1
         oxygensClosureDic["getSpoNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getSpoNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   
   ///MARK :Get all motion data by type
   /// - Parameter :
   ///        - type : nil query all type
   /// - Returns:
   public func getSportRecord(_ type:SportType?,model:@escaping sportsClosure) {
      serialQueue.sync {
         requestId+=1
         sportsClosureDic["getSportRecord\(requestId)"] = model
         methodChannel?.invokeMethod("getSportRecord\(requestId)", arguments: type?.rawValue ?? 1000)
      }
      
   }
   
   ///MARK :Get sport details
   /// - Parameter :
   ///         -id：SportModel.id
   /// - Returns:
   public func getSportDetails(id:Int?,model:@escaping sportClosure) {
      serialQueue.sync {
         requestId+=1
         sportClosureDic["getSportDetails\(requestId)"] = model
         methodChannel?.invokeMethod("getSportDetails\(requestId)", arguments: id)
      }
      
   }
   
   ///MARK :Query sports data by time range and type
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   ///      - type : nil query all type
   /// - Returns:
   public func getSportTimeData(startTime:String,endTime:String,_ type:SportType?,model:@escaping sportsClosure) {
      serialQueue.sync {
         requestId+=1
         sportsClosureDic["getSportTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getSportTimeData\(requestId)", arguments: [startTime ,endTime,type?.rawValue ?? 1000] as [Any])
      }
      
   }
   
   ///MARK:  Delete a piece of exercise data
   /// - Parameter :
   ///    id:SportModel.id
   /// - Returns:
   public func delSportRecord(id:Int,model:@escaping baseClosure) {
      serialQueue.sync {
         requestId+=1
         baseClosureDic["delSportRecord\(requestId)"] = model
         methodChannel?.invokeMethod("delSportRecord\(requestId)", arguments: id)
      }
      
   }
   
   ///MARK :Get HRV Health Data
   /// - Parameter :
   ///      - startTime   2023-08-03
   ///      - endTime    2023-08-03
   /// - Returns:
   public func getHrvNewTimeData(startTime:String,endTime:String,model:@escaping hrvsClosure) {
      serialQueue.sync {
         requestId+=1
         hrvsClosureDic["getHrvNewTimeData\(requestId)"] = model
         methodChannel?.invokeMethod("getHrvNewTimeData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   
   ///MARK :Get all bound devices
   /// - Parameter :
   /// - Returns:
   public func getBindDevice(model:@escaping devicesBack) {
      serialQueue.sync {
         requestId+=1
         devicesBackDic["getBindDevice\(requestId)"] = model
         methodChannel?.invokeMethod("getBindDevice\(requestId)", arguments: "")
      }
      
   }
   
   ///*******************************
   ///Query unuploaded data
   ///*******************************
   
   public func getSportUploadStatus(model:@escaping sportsClosure) {
      serialQueue.sync {
         requestId+=1
         sportsClosureDic["getSportUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getSportUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func getActivityUploadStatus(model:@escaping activitysClosure) {
      serialQueue.sync {
         requestId+=1
         activitysClosureDic["getActivityUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getActivityUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func getHeartRateUploadStatus(model:@escaping heartRatesClosure) {
      serialQueue.sync {
         requestId+=1
         heartRatesClosureDic["getHeartRateUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getHeartRateUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func getHrvUploadStatus(model:@escaping hrvsClosure) {
      serialQueue.sync {
         requestId+=1
         hrvsClosureDic["getHrvUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getHrvUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func getNoiseUploadStatus(model:@escaping noisesClosure) {
      serialQueue.sync {
         requestId+=1
         noisesClosureDic["getNoiseUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getNoiseUploadStatus\(requestId)", arguments: "")
      }
      
   }
   public func getStressUploadStatus(model:@escaping stresssClosure) {
      serialQueue.sync {
         requestId+=1
         stresssClosureDic["getStressUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getStressUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func getSleepUploadDays(model:@escaping sleepsClosure) {
      serialQueue.sync {
         requestId+=1
         sleepsClosureDic["getSleepUploadDays\(requestId)"] = model
         methodChannel?.invokeMethod("getSleepUploadDays\(requestId)", arguments: "")
      }
      
   }
   
   public func getSpoUploadStatus(model:@escaping oxygensClosure) {
      serialQueue.sync {
         requestId+=1
         oxygensClosureDic["getSpoUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getSpoUploadStatus\(requestId)", arguments: "")
      }
      
   }
   
   public func setDBUser(_ userID:Int?) {
      methodChannel?.invokeMethod("setDBUser", arguments: userID ?? 1)
   }
   
   public func updateDBUploadStatus(_ type:SyncServerType) {
      methodChannel?.invokeMethod("updateDBUploadStatus", arguments: type.rawValue)
   }
   
   public func rawQueryDB(_ sql:String,model:@escaping rawQueryDBClosure) {
      serialQueue.sync {
         requestId+=1
         rawQueryDBClosureDic["rawQueryDB\(requestId)"] = model
         methodChannel?.invokeMethod("rawQueryDB\(requestId)", arguments: sql)
      }
      
   }
   
   public func encodeOnlineFile(_ ephemerisModel :EphemerisModel,model:@escaping ephemerisData,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         ephemerisClosureDic["encodeOnlineFile\(requestId)"] = model
         failureArgumentDic["encodeOnlineFile\(requestId)"] = failure
         let json = try? JSONEncoder().encode(ephemerisModel)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodeOnlineFile\(requestId)", arguments: str)
         }
      }
      
   }
   
   public func encodeOfflineFile(_ ephemerisModel :EphemerisModel,model:@escaping ephemerisData,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         ephemerisClosureDic["encodeOfflineFile\(requestId)"] = model
         failureArgumentDic["encodeOfflineFile\(requestId)"] = failure
         let json = try? JSONEncoder().encode(ephemerisModel)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodeOfflineFile\(requestId)", arguments: str)
         }
      }
      
   }
   
   public func encodePhoneFile(_ phoneModel :[PhoneModel],model:@escaping ephemerisData,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         ephemerisClosureDic["encodePhoneFile\(requestId)"] = model
         failureArgumentDic["encodePhoneFile\(requestId)"] = failure
         let json = try? JSONEncoder().encode(phoneModel)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodePhoneFile\(requestId)", arguments: str)
         }
      }
      
   }
   
   ///Get app log
   public func getLogPath(path: @escaping ((_ path:String) -> ())){
      logPathClosure = path
      methodChannel?.invokeMethod("getLogPath", arguments:"")
   }
   ///Get firmware logs in real time
   public func getFirmwareLogPath(path: @escaping ((_ path:String) -> ())){
      logPathClosure = path
      methodChannel?.invokeMethod("firmwareLogPath", arguments:"")
   }
   ///Check the log file and save only 7 days of data
   public func checkLogFile(){
      methodChannel?.invokeMethod("checkLogFile", arguments:"")
   }
   
   ///Analytical dial
   public func parseDial(_ path:String,_ width:Int,_ height:Int, _ radius:Int, _ platformType:Platform ,model:@escaping parseDialBase) {
      serialQueue.sync {
         requestId+=1
         parseDialClosureDic["parseDial\(requestId)"] = model
         methodChannel?.invokeMethod("parseDial\(requestId)", arguments: [path,width,height,radius,platformType.rawValue])
      }
      
   }
   
   ///Analytical photo dial
   public func parsePhotoDial(_ path:String,_ width:Int,_ height:Int, _ radius:Int, _ platformType:Platform ,model:@escaping parsePhotoDialBase) {
      serialQueue.sync {
         requestId+=1
         parsePhotoDialClosureDic["parsePhotoDial\(requestId)"] = model
         methodChannel?.invokeMethod("parsePhotoDial\(requestId)", arguments: [path,width,height,radius,platformType.rawValue])
      }
      
   }
   
   ///Get the watch face generated image
   public func getPreviewImage(model:@escaping previewImageBase) {
      serialQueue.sync {
         requestId+=1
         previewImageClosureDic["getPreviewImage\(requestId)"] = model
         methodChannel?.invokeMethod("getPreviewImage\(requestId)", arguments: "")
      }
      
   }
   
   ///Set color
   public func setCurrentColor(selectIndex:Int,model:@escaping parseDialBase) {
      serialQueue.sync {
         requestId+=1
         parseDialClosureDic["setCurrentColor\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentColor\(requestId)", arguments: selectIndex)
      }
      
   }
   
   ///Set color
   public func setCurrentPhotoColor(photoSelectIndex:Int,selectIndex:Int,model:@escaping parsePhotoDialBase) {
      serialQueue.sync {
         requestId+=1
         parsePhotoDialClosureDic["setCurrentPhotoColor\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentPhotoColor\(requestId)", arguments: [photoSelectIndex,selectIndex])
      }
      
   }
   
   ///set background
   public func setCurrentBackgroundImagePath(selectIndex:Int,model:@escaping parseDialBase) {
      serialQueue.sync {
         requestId+=1
         parseDialClosureDic["setCurrentBackgroundImagePath\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentBackgroundImagePath\(requestId)", arguments: selectIndex)
      }
      
   }
   
   ///Set clock position
   public func setCurrentClockPosition(photoSelectIndex:Int,selectIndex:Int,model:@escaping parsePhotoDialBase) {
      serialQueue.sync {
         requestId+=1
         parsePhotoDialClosureDic["setCurrentClockPosition\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentClockPosition\(requestId)", arguments: [photoSelectIndex,selectIndex])
      }
      
   }
   
   ///Set clock position
   public func setCurrentPhotoBackgroundImagePath(photoImagePaths:[String],selectIndex:Int,model:@escaping parsePhotoDialBase) {
      serialQueue.sync {
         requestId+=1
         parsePhotoDialClosureDic["setCurrentPhotoBackgroundImagePath\(requestId)"] = model
         let dic:[String : Any] = ["photoImagePaths":photoImagePaths,"photoSelectIndex":selectIndex]
         methodChannel?.invokeMethod("setCurrentPhotoBackgroundImagePath\(requestId)", arguments: dic)
      }
      
   }
   
   ///Set function
   public func setCurrentFunction(selectIndex:[Int],model:@escaping parseDialBase) {
      serialQueue.sync {
         requestId+=1
         parseDialClosureDic["setCurrentFunction\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentFunction\(requestId)", arguments: selectIndex)
      }
      
   }
   
   ///Generate watch face
   public func encodeDial(model:@escaping dialDataBase) {
      serialQueue.sync {
         requestId+=1
         dialDataClosureDic["encodeDial\(requestId)"] = model
         methodChannel?.invokeMethod("encodeDial\(requestId)", arguments: "")
      }
      
   }
   
   ///Generate watch face
   public func encodePhotoDial(model:@escaping dialDataBase) {
      serialQueue.sync {
         requestId+=1
         dialDataClosureDic["encodePhotoDial\(requestId)"] = model
         methodChannel?.invokeMethod("encodePhotoDial\(requestId)", arguments: "")
      }
      
   }
   
   //    public func ephemerisInit(keyId:String,publicKey:String,model:@escaping gpsBase){
   //        _gpsClosure = model
   //        methodChannel?.invokeMethod("ephemerisInit\(requestId)", arguments: [keyId,publicKey])
   //    }
   
   public func ephemerisInitGPS(model:EphemerisGPSModel){
      let json = try? JSONEncoder().encode(model)
      if let data = json, let str = String(data: data, encoding: .utf8) {
         methodChannel?.invokeMethod("ephemerisGPS\(requestId)", arguments: str)
      }
   }
   
   public func phoneBookInit(){
      methodChannel?.invokeMethod("phoneBookInit", arguments: "")
   }
   
   public func monitorPhone(){
      methodChannel?.invokeMethod("monitorPhone", arguments: "")
   }
   
   public func checkPhoneBookPermissions(model:@escaping boolBase){
      serialQueue.sync {
         requestId+=1
         boolClosureDic["checkPhoneBookPermissions\(requestId)"] = model
         methodChannel?.invokeMethod("checkPhoneBookPermissions\(requestId)", arguments: "")
      }
      
   }
   
   public func requestPhoneBookPermissions(model:@escaping boolBase){
      serialQueue.sync {
         requestId+=1
         boolClosureDic["requestPhoneBookPermissions\(requestId)"] = model
         methodChannel?.invokeMethod("requestPhoneBookPermissions\(requestId)", arguments: "")
      }
      
   }
   
   public func getOTAUpgradeVersion(model:@escaping valueBase){
      serialQueue.sync {
         requestId+=1
         valueClosureDic["getOTAUpgradeVersion\(requestId)"] = model
         methodChannel?.invokeMethod("getOTAUpgradeVersion\(requestId)", arguments: "")
      }
      
   }
   
   public func getOTAUpgradeState(fileName:String,fileData:Data,model:@escaping upgradeStateBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         upgradeStateClosureDic["getOTAUpgradeState\(requestId)"] = model
         failureArgumentDic["getOTAUpgradeState\(requestId)"]=failure
         var intArray: [Int] = []
         fileData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let buffer = UnsafeBufferPointer(start: bytes, count: fileData.count)
            intArray = Array(buffer).map { Int($0) }
         }
         let dic:[String:Any] = ["fileName":fileName,"fileData":intArray]
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("getOTAUpgradeState\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
      
   }
   
   ///MARK :Monitor the status of connected devices
   /// - Parameter :
   ///      - listenDeviceState：
   /// - Returns:
   public func bluetoothStateListen(listen:@escaping (_ state:BluetoothState)->()) {
      _bluetoothStateListen = listen
   }
   
   public func encodeContacts(_ contactsIconModels :[ContactsIconModel], model:@escaping ContactsIconData,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         contactsIconClosureDic["encodeContacts\(requestId)"] = model
         failureArgumentDic["encodeContacts\(requestId)"] = failure
         var list:[String] = []
         contactsIconModels.forEach { contactsIconModel in
            let json = try? JSONEncoder().encode(contactsIconModel)
            if let data = json, let str = String(data: data, encoding: .utf8) {
               list.append(str)
            }
         }
         methodChannel?.invokeMethod("encodeContacts\(requestId)", arguments: list)
      }
   }
   
   public func watchResetListen(listen:@escaping ()->()) {
      _watchResetListen = listen
   }
   
   
   public func getCalendar(model:@escaping calendarBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         calendarDic["getCalendar\(requestId)"] = model
         failureArgumentDic["getCalendar\(requestId)"] = failure
         methodChannel?.invokeMethod("getCalendar\(requestId)", arguments: "")
      }
   }
   
   public func setCalendar(model:protocol_calendar_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setCalendar\(requestId)"] = success;
         failureArgumentDic["setCalendar\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setCalendar\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func getWatchDirection(model:@escaping watchDirectionBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         watchDirectionDic["getDirectionWatch\(requestId)"] = model
         failureArgumentDic["getDirectionWatch\(requestId)"] = failure
         methodChannel?.invokeMethod("getDirectionWatch\(requestId)", arguments: "")
      }
   }
   
   public func setWatchDirection(model:protocol_watch_direction_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setDirectionWatch\(requestId)"] = success;
         failureArgumentDic["setDirectionWatch\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setDirectionWatch\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func getMorning(model:@escaping morningBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         morningDic["getMorning\(requestId)"] = model
         failureArgumentDic["getMorning\(requestId)"] = failure
         methodChannel?.invokeMethod("getMorning\(requestId)", arguments: "")
      }
   }
   
   public func setMorning(model:protocol_good_morning_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setMorning\(requestId)"] = success;
         failureArgumentDic["setMorning\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMorning\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func getHealthSnapshotList(page:Int = 1,size:Int = 20,model:@escaping healthSnapshotBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         healthSnapshotDic["getHealthSnapshotList\(requestId)"] = model
         failureArgumentDic["getHealthSnapshotList\(requestId)"] = failure
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: ["page":page,"size":size], options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("getHealthSnapshotList\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
   }
   
   public func getMusicList(page:Int = 1,size:Int = 20,model:@escaping musicBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         musicDic["getMusicList\(requestId)"] = model
         failureArgumentDic["getMusicList\(requestId)"] = failure
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: ["page":page,"size":size], options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("getMusicList\(requestId)", arguments: JSONString)
            }
         }catch{
            print("Error converting string to dictionary: \(error.localizedDescription)")
         }
      }
   }
   public func delMusicList(model:protocol_music_file_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["delMusicList\(requestId)"] = success;
         failureArgumentDic["delMusicList\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("delMusicList\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func uploadMusic(musicModel:CreekMusicModel,fileData:Data,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         progressDic["musicUpload\(requestId)"] = uploadProgress
         successDic["musicUpload\(requestId)"] = uploadSuccess;
         failureArgumentDic["musicUpload\(requestId)"] = uploadFailure
         let json = try? JSONEncoder().encode(musicModel)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("musicUpload\(requestId)", arguments: [str,fileData])
         }
      }
      
   }
   
   public func uploadSportCourse(courseModels:[CourseModel],uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         progressDic["sportCourseUpload\(requestId)"] = uploadProgress
         successDic["sportCourseUpload\(requestId)"] = uploadSuccess;
         failureArgumentDic["sportCourseUpload\(requestId)"] = uploadFailure
         let json = try? JSONEncoder().encode(courseModels)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("sportCourseUpload\(requestId)", arguments: str)
         }
      }
   }
   
   
   public func getCourse(model:@escaping courseBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         courseDic["getCourse\(requestId)"] = model
         failureArgumentDic["getCourse\(requestId)"] = failure
         methodChannel?.invokeMethod("getCourse\(requestId)", arguments: "")
      }
   }
   
   public func delCourse(model:protocol_exercise_course_list_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["delCourse\(requestId)"] = success;
         failureArgumentDic["delCourse\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("delCourse\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func getGPXEncodeUint8List(data:Data,geoId:Int,sportType:SportType,model:@escaping geoAddressBase,encode:@escaping GPXBase){
      _geoAddressClosure = model
      serialQueue.sync {
         requestId+=1
         GPXDic["getGPXEncodeUint8List\(requestId)"] = encode
         methodChannel?.invokeMethod("getGPXEncodeUint8List\(requestId)", arguments: [data,geoId,sportType.rawValue])
      }
   }
   
   public func upLoadGeo(data:Data,geoId:Int,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument) {
      
      serialQueue.sync {
         requestId+=1
         progressDic["geoUpload\(requestId)"] = uploadProgress
         successDic["geoUpload\(requestId)"] = uploadSuccess;
         failureArgumentDic["geoUpload\(requestId)"] = uploadFailure
         methodChannel?.invokeMethod("geoUpload\(requestId)", arguments: [data,geoId])
      }
   }
   
   public func getGeo(model:@escaping geoBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         geoDic["getGeo\(requestId)"] = model
         failureArgumentDic["getGeo\(requestId)"] = failure
         methodChannel?.invokeMethod("getGeo\(requestId)", arguments: "")
      }
   }
   
   public func delGeo(geoIds:[Int],success:@escaping successBase,failure:@escaping failureArgument) {
      var operate =  protocol_geobin_operate()
      geoIds.forEach { geoId in
         var item  = protocol_geobin_list_item()
         item.geobinID = UInt64(geoId)
         operate.geobinItems.append(item)
      }
      serialQueue.sync {
         requestId+=1
         successDic["delGeo\(requestId)"] = success;
         failureArgumentDic["delGeo\(requestId)"] = failure
         do{
            let data = try operate.serializedData()
            methodChannel?.invokeMethod("delGeo\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func routeAddress(model:String){
      methodChannel?.invokeMethod("routeAddress\(requestId)", arguments: model)
   }
   
   ///MARK :Get firmware user information and preferences
   /// - Parameter :
   ///      - model：call back protocol_user_info_operate
   /// - Returns:
   public func getAuthorizationCode(model:@escaping authorizationCodeBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         authorizationCodeDic["getAuthorizationCode\(requestId)"] = model
         failureArgumentDic["getAuthorizationCode\(requestId)"] = failure
         methodChannel?.invokeMethod("getAuthorizationCode\(requestId)", arguments: "")
      }
      
   }
   
   
   public func getWatchSensor(model:@escaping watchSensorBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         watchSensorDic["getSensorWatch\(requestId)"] = model
         failureArgumentDic["getSensorWatch\(requestId)"] = failure
         methodChannel?.invokeMethod("getSensorWatch\(requestId)", arguments: "")
      }
   }
   
   public func setWatchSensor(model:protocol_watch_sensors_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSensorWatch\(requestId)"] = success;
         failureArgumentDic["setSensorWatch\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSensorWatch\(requestId)", arguments: data)
         }catch{
            
         }
      }
      
   }
   
   public func getWaterAssistant(model:@escaping waterAssistantBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         waterAssistantDic["getAssistantWater\(requestId)"] = model
         failureArgumentDic["getAssistantWater\(requestId)"] = failure
         methodChannel?.invokeMethod("getAssistantWater\(requestId)", arguments: "")
      }
   }
   
   //   public func setWaterAssistant(model:protocol_water_assistant_operate,success:@escaping successBase,failure:@escaping failureArgument) {
   //      serialQueue.sync {
   //         requestId+=1
   //         successDic["setWaterAssistant\(requestId)"] = success;
   //         failureArgumentDic["setWaterAssistant\(requestId)"] = failure
   //         do{
   //             let data = try model.serializedData()
   //             methodChannel?.invokeMethod("setWaterAssistant\(requestId)", arguments: data)
   //         }catch{
   //
   //         }
   //      }
   //
   //   }
   
   ///AI configuration
   public func aiVoiceConfig(keyId:String,publicKey:String){
      requestId+=1
      methodChannel?.invokeMethod("aiVoiceConfig\(requestId)", arguments: [keyId,publicKey])
   }
   
   ///AI configuration   CN US AF ..........
   public func setAiVoiceCountry(countryCode:String){
      requestId+=1
      methodChannel?.invokeMethod("setAiVoiceCountry\(requestId)", arguments: countryCode)
   }
   
   ///AI configuration
   public func setAiVoiceCity(cityName:String){
      requestId+=1
      methodChannel?.invokeMethod("setAiVoiceCity\(requestId)", arguments: cityName)
   }
   ///Real-time monitoring of sports data
   public func liveSportDataListen(listen:@escaping (_ model:protocol_exercise_sync_realtime_info) -> ()){
      _liveSportDataListen = listen
   }
   
   ///Real-time monitoring of motion control
   public func liveSportControlListen(listen:@escaping (_ model:protocol_exercise_control_operate) -> ()){
      _liveSportControlListen = listen
   }
   
   public func setSportControl(controlType:exercise_control_type,_ sportType:sport_type = .orun,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setSportControl\(requestId)"] = success;
         failureArgumentDic["setSportControl\(requestId)"] = failure
         var operate = protocol_exercise_control_operate()
         operate.controlType = controlType
         operate.sportType = sportType
         do{
            let data = try operate.serializedData()
            methodChannel?.invokeMethod("setSportControl\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   ///MARK: quire about hardware upgrades
   ///MARK: langCode： en,zh,de,fr,es,it,pt,ja,ru,tr,th,ko,et,lt,lv,bg,el,pl,vi,cs,sk,hu,ms,id,hi,he,ro,uk,ar,nl,fa,zh_Hant
   public func queryFirmwareUpdate(langCode:String = "en",model:@escaping firmwareUpdateBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         firmwareUpdateDic["queryFirmwareUpdate\(requestId)"] = model
         failureArgumentDic["queryFirmwareUpdate\(requestId)"] = failure
         methodChannel?.invokeMethod("queryFirmwareUpdate\(requestId)", arguments: langCode)
      }
      
   }
   
   ///Start firmware update
   public func startFirmwareUpdate(url:String,downProgress:@escaping progressBase, downSuccess:@escaping successBase, downFailure:@escaping failureArgument,uploadProgress:@escaping progressBase, uploadSuccess:@escaping successBase, uploadFailure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         progressDic["downstartFirmwareUpdate\(requestId)"] = downProgress
         successDic["downstartFirmwareUpdate\(requestId)"] = downSuccess;
         failureArgumentDic["downstartFirmwareUpdate\(requestId)"] = downFailure
         progressDic["startFirmwareUpdate\(requestId)"] = uploadProgress
         successDic["startFirmwareUpdate\(requestId)"] = uploadSuccess;
         failureArgumentDic["startFirmwareUpdate\(requestId)"] = uploadFailure
         methodChannel?.invokeMethod("startFirmwareUpdate\(requestId)", arguments: url)
      }
   }
   
   ///Request pairing
   public func requestPairing(){
      requestId+=1
      methodChannel?.invokeMethod("requestPairing\(requestId)", arguments: "")
   }
   
   
   ///Analytical video dial
   public func parseVideoDial(_ path:String,_ width:Int,_ height:Int, _ radius:Int, _ platformType:Platform ,model:@escaping parseVideoDialBase) {
      serialQueue.sync {
         requestId+=1
         parseVideoDialClosureDic["parseVideoDial\(requestId)"] = model
         methodChannel?.invokeMethod("parseVideoDial\(requestId)", arguments: [path,width,height,radius,platformType.rawValue])
      }
      
   }
   
   ///Analytical video dial
   public func setVideoDial(_ videoPath:String,_ startSecond:Int,_ endSecond:Int, _ cropW:Double, _ cropH:Double,_ cropX:Double,_ cropY:Double,model:@escaping backStringBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["setVideoDial\(requestId)"] = model
         failureArgumentDic["setVideoDial\(requestId)"] = failure
         methodChannel?.invokeMethod("setVideoDial\(requestId)", arguments: [videoPath,startSecond,endSecond,cropW,cropH,cropX,cropY])
      }
      
   }
   
   ///Set color
   public func setCurrentVideoColor(selectIndex:Int,model:@escaping parseVideoDialBase) {
      serialQueue.sync {
         requestId+=1
         parseVideoDialClosureDic["setCurrentVideoColor\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentVideoColor\(requestId)", arguments: [0,selectIndex])
      }
   }
   
   public func setCurrentVideoClockPosition(selectIndex:Int,model:@escaping parseVideoDialBase) {
      serialQueue.sync {
         requestId+=1
         parseVideoDialClosureDic["setCurrentVideoClockPosition\(requestId)"] = model
         methodChannel?.invokeMethod("setCurrentVideoClockPosition\(requestId)", arguments: [0,selectIndex])
      }
   }
   
   ///Generate watch face
   public func encodeVideoDial(model:@escaping dialDataBase) {
      serialQueue.sync {
         requestId+=1
         dialDataClosureDic["encodeVideoDial\(requestId)"] = model
         methodChannel?.invokeMethod("encodeVideoDial\(requestId)", arguments: "")
      }
   }
   
   public func delBindDevice(deviceId:String, success:@escaping successBase, failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         successDic["delBindDevice\(requestId)"] = success;
         failureArgumentDic["delBindDevice\(requestId)"] = failure
         methodChannel?.invokeMethod("delBindDevice\(requestId)", arguments: deviceId)
      }
   }
   
   
   public func calendarConfig(timerMinute:Int,systemCalendarName:String,isSupport:Bool = false,model:@escaping backStringBase){
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["calendarConfig\(requestId)"] = model
         methodChannel?.invokeMethod("calendarConfig\(requestId)", arguments: [timerMinute,systemCalendarName,isSupport ? 1 : 0])
      }
   }
   
   public func checkCalendarPermission(model:@escaping boolBase){
      serialQueue.sync {
         requestId+=1
         boolClosureDic["checkCalendarPermission\(requestId)"] = model
         methodChannel?.invokeMethod("checkCalendarPermission\(requestId)", arguments: "")
      }
   }
   public func requestCalendarPermission(model:@escaping boolBase){
      serialQueue.sync {
         requestId+=1
         boolClosureDic["requestCalendarPermission\(requestId)"] = model
         methodChannel?.invokeMethod("requestCalendarPermission\(requestId)", arguments: "")
      }
   }
   
   public func syncCalendar(){
      serialQueue.sync {
         requestId+=1
         methodChannel?.invokeMethod("syncCalendar\(requestId)", arguments: "")
      }
   }
   
   
   public func aiChat(content:String,threadId:String = "",userId:String,replyMessage:@escaping backStringBase,courseJson:@escaping backStringBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["aiChat\(requestId)"] = replyMessage
         backStringBaseDic["aicourse"] = courseJson
         failureArgumentDic["aiChat\(requestId)"] = failure
         methodChannel?.invokeMethod("aiChat\(requestId)", arguments: [content,threadId,userId])
      }
   }
   ///langCode： en,zh,de,fr,es,it,pt,ja,ru,tr,th,ko,et,lt,lv,bg,el,pl,vi,cs,sk,hu,ms,id,hi,he,ro,uk,ar,nl,fa,zh_Hant............
   ///height  /cm
   ///weight  /kg
   public func aiAnalysisActivity(activityModel:ActivityModel,goalsModel:GoalsModel,langCode:String = "en",userId:String,height:Int,weight:Double,replyMessage:@escaping backStringBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["aiAnalysisActivity\(requestId)"] = replyMessage
         failureArgumentDic["aiAnalysisActivity\(requestId)"] = failure
         guard
            let activityData = try? JSONEncoder().encode(activityModel),
            let activityStr = String(data: activityData, encoding: .utf8),
            let goalsData = try? JSONEncoder().encode(goalsModel),
            let goalsStr = String(data: goalsData, encoding: .utf8)
         else {
            print("Failed to encode activityModel or goalsModel")
            return
         }
         methodChannel?.invokeMethod("aiAnalysisActivity\(requestId)", arguments: [activityStr,goalsStr,langCode,userId,height,weight])
      }
      
   }
   
   public func aiAnalysisSleep(sleepModel:SleepModel,langCode:String = "en",userId:String,replyMessage:@escaping backStringBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["aiAnalysisSleep\(requestId)"] = replyMessage
         failureArgumentDic["aiAnalysisSleep\(requestId)"] = failure
         guard
            let sleepData = try? JSONEncoder().encode(sleepModel),
            let sleepStr = String(data: sleepData, encoding: .utf8)
         else {
            print("Failed to encode sleepModel")
            return
         }
         methodChannel?.invokeMethod("aiAnalysisSleep\(requestId)", arguments: [sleepStr,langCode,userId])
      }
      
   }
   
   public func aiAnalysisSport(sportModel:SportModel,langCode:String = "en",userId:String,age:Int,gender:gender_type,replyMessage:@escaping backStringBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         backStringBaseDic["aiAnalysisSport\(requestId)"] = replyMessage
         failureArgumentDic["aiAnalysisSport\(requestId)"] = failure
         guard
            let sportData = try? JSONEncoder().encode(sportModel),
            let sportStr = String(data: sportData, encoding: .utf8)
         else {
            print("Failed to encode sportModel")
            return
         }
         methodChannel?.invokeMethod("aiAnalysisSport\(requestId)", arguments: [sportStr,langCode,age,userId,"\(gender.rawValue + 1)"])
      }
   }
   
   ///MARK :set weather
   /// - Parameter :
   ///      - model: protocol_weather_operate
   /// - Returns:
   public func setZSWeather(model:protocol_zs_weather_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setZSWeather\(requestId)"] = success;
         failureArgumentDic["setZSWeather\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setZSWeather\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func aiDialConfig(voiceData:@escaping dialDataBase,confirmText:@escaping backStringBase,success:@escaping successBase,failure:@escaping failureArgument){
      dialDataClosureDic["aiDialPcm"] = voiceData
      backStringBaseDic["aiDialText"] = confirmText
      successDic["aiDialConfig"] = success;
      failureArgumentDic["aiDialConfig"] = failure
      methodChannel?.invokeMethod("aiDialConfig", arguments: "")
   }
   
   public func aiDialSendText(text:String,type:VoiceDialType){
      methodChannel?.invokeMethod("aiDialSendText", arguments: [text,type.rawValue])
   }
   
   public func aiDialSendImages(images:[Data],type:VoiceDialType,dialName:String = "aidial"){
      methodChannel?.invokeMethod("aiDialSendImages", arguments: [images,type.rawValue,dialName])
   }
   
   public func saveBindDevice(){
      methodChannel?.invokeMethod("saveBindDevice", arguments: "")
   }
   
   public func initGlobalConfig(keyId:String,publicKey:String){
      methodChannel?.invokeMethod("initGlobalConfig", arguments: [keyId,publicKey])
   }
   
   
   public func ephemerisListen(listen:@escaping (() -> ())){
      _ephemerisListen = listen
   }
   
   public func getEphemerisUpdateTime(model:@escaping ephemerisDataBase){
      serialQueue.sync {
         requestId+=1
         ephemerisDataBaseDic["getEphemerisUpdateTime\(requestId)"] = model
         methodChannel?.invokeMethod("getEphemerisUpdateTime\(requestId)", arguments: "str")
      }
   }
   
   public func updateEphemeris(model:EphemerisGPSModel,isBackground:Bool = false,success:@escaping successBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         successDic["updateEphemeris\(requestId)"] = success;
         failureArgumentDic["updateEphemeris\(requestId)"] = failure
         let json = try? JSONEncoder().encode(model)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            let value = isBackground ? 1 : 0
            methodChannel?.invokeMethod("updateEphemeris\(requestId)", arguments: [str,value])
         }
      }
   }
   
   ///MARK : Get volume adjust settings
   /// - Parameters:
   ///      - model: Callback with volume adjust data
   ///      - failure: Failure callback with error code and message
   /// - Returns: Volume adjust settings from device
   public func getVolumeAdjust(model: @escaping volumeAdjustBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getVolumeAdjust\(requestId)"
         volumeAdjustDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   ///MARK : Set volume adjust settings
   /// - Parameters:
   ///      - model: Volume adjust configuration data
   ///      - success: Success callback
   ///      - failure: Failure callback with error code and message
   /// - Returns: Success/failure status
   public func setVolumeAdjust(model: protocol_volume_adjust_operate, success: @escaping successBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "setVolumeAdjust\(requestId)"
         successDic[methodName] = success
         failureArgumentDic[methodName] = failure
         
         do {
            let data = try model.serializedData()
            methodChannel?.invokeMethod(methodName, arguments: data)
         } catch {
            print("Error serializing volume adjust data: \(error.localizedDescription)")
            failure(-1, "Failed to serialize volume adjust data")
            // Clean up dictionaries
            successDic.removeValue(forKey: methodName)
            failureArgumentDic.removeValue(forKey: methodName)
         }
      }
   }
   
   ///MARK : Get blood pressure data
   /// - Parameters:
   ///      - model: Callback with blood pressure data
   ///      - failure: Failure callback with error code and message
   /// - Returns: Blood pressure measurements from device
   ///
   ///
   
   public func getBloodPressure(page:Int = 1,size:Int = 20,model:@escaping bloodPressureBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         bloodPressureDic["getBloodPressure\(requestId)"] = model
         failureArgumentDic["getBloodPressure\(requestId)"] = failure
         do{
            let jsonData = try JSONSerialization.data(withJSONObject: ["page":page,"size":size], options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
               methodChannel?.invokeMethod("getBloodPressure\(requestId)", arguments: JSONString)
            }
         }catch{
            let methodName = "getBloodPressure\(requestId)";
            print("Error converting string to dictionary: \(error.localizedDescription)")
            failure(-1, "Failed to serialize blood pressure data")
            successDic.removeValue(forKey: methodName)
            failureArgumentDic.removeValue(forKey: methodName)
         }
      }
   }
   
   
   public func getMedicineRemind(model: @escaping medicineRemindBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getMedicineRemind\(requestId)"
         medicineRemindDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   
   public func setMedicineRemind(model: protocol_medicine_remind_operate, success: @escaping successBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "setMedicineRemind\(requestId)"
         successDic[methodName] = success
         failureArgumentDic[methodName] = failure
         
         do {
            let data = try model.serializedData()
            methodChannel?.invokeMethod(methodName, arguments: data)
         } catch {
            print("Error serializing medicine remind data: \(error.localizedDescription)")
            failure(-1, "Failed to serialize medicine remind data")
            // Clean up dictionaries
            successDic.removeValue(forKey: methodName)
            failureArgumentDic.removeValue(forKey: methodName)
         }
      }
   }
   
   ///训练负荷
   public func getTrainingLoad(model: @escaping trainLoadBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getTrainingLoad\(requestId)"
         trainLoadBaseDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   /// 获取有氧适能
   public func getCardioFitness(model: @escaping cardioFitnessBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getFitnessCardio\(requestId)"
         cardioFitnessBaseDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   /// 设置有氧适能
   public func setCardioFitness(model:protocol_cardio_fitness_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setFitnessCardio\(requestId)"] = success;
         failureArgumentDic["setFitnessCardio\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setFitnessCardio\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   ///点测获取健康数据
   public func getClickHealthMeasure(type: ring_health_type,model: @escaping clickHealthMeasureBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getClickHealthMeasure\(requestId)"
         clickHealthMeasureDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: type.rawValue)
      }
   }
   
   ///点测数据设置
   public func setClickHealthMeasure(model: protocol_ring_click_measure_operate, success: @escaping clickHealthMeasureBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "setClickHealthMeasure\(requestId)"
         clickHealthMeasureDic[methodName] = success
         failureArgumentDic[methodName] = failure
         
         do {
            let data = try model.serializedData()
            methodChannel?.invokeMethod(methodName, arguments: data)
         } catch {
            print("Error serializing setClickHealthMeasure data: \(error.localizedDescription)")
            failure(-1, "Failed to serialize setClickHealthMeasure data")
            // Clean up dictionaries
            successDic.removeValue(forKey: methodName)
            failureArgumentDic.removeValue(forKey: methodName)
         }
      }
   }
   
   ///戒指触发 App 提醒开关
   public func getWatchReminderWitch(model: @escaping watchReminderWitchBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getWatchReminderWitch\(requestId)"
         watchReminderWitchDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   ///戒指触发 App 提醒开关
   public func setWatchReminderWitch(model: protocol_remind_mark_switch_operate, success: @escaping successBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "setWatchReminderWitch\(requestId)"
         successDic[methodName] = success
         failureArgumentDic[methodName] = failure
         
         do {
            let data = try model.serializedData()
            methodChannel?.invokeMethod(methodName, arguments: data)
         } catch {
            print("Error serializing setWatchReminderWitch data: \(error.localizedDescription)")
            failure(-1, "Failed to serialize setWatchReminderWitch data")
            // Clean up dictionaries
            successDic.removeValue(forKey: methodName)
            failureArgumentDic.removeValue(forKey: methodName)
         }
      }
   }
   
   
   ///MARK :Get af Health Data
   /// - Parameter :
   ///      - startTime 2023-08-03
   ///      - endTime 2023-08-03
   /// - Returns:
   public func getAfData(startTime:String,endTime:String,model: @escaping afClosure) {
      serialQueue.sync {
         requestId+=1
         afClosureDic["getAfData\(requestId)"] = model
         methodChannel?.invokeMethod("getAfData\(requestId)", arguments: [startTime ,endTime])
      }
      
   }
   
   
   ///MARK :Get af Health Data
   /// - Parameter :
   ///      - startTime 2023-08-03
   ///      - endTime 2023-08-03
   /// - Returns:
   public func getAfPpgData(startTime:String,endTime:String,model: @escaping afPpgClosure) {
      serialQueue.sync {
         requestId+=1
         afPpgClosureDic["getAfPpgData\(requestId)"] = model
         methodChannel?.invokeMethod("getAfPpgData\(requestId)", arguments: [startTime ,endTime])
      }
   }
   
   ///Smart hydration
   public func getHydrateAssistant(model: @escaping hydrateAssistantBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getHydrateAssistant\(requestId)"
         hydrateAssistantBaseDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   ///Alarm reminder notification
   public func ringAlarmVibrateListen(listen:@escaping (_ model:protocol_ring_alarm_vibrate_notify_operate) -> ()){
      _ringAlarmVibrateListen = listen
   }
   
   ///motion recognition
   public func motionRecognitionListen(listen:@escaping (_ model:protocol_ring_motion_recognition_operate) -> ()){
      _motionRecognitionListen = listen
   }
   ///Ring reminder monitoring
   public func ringReminderListen(listen:@escaping (_ model:protocol_ring_remind_mark_operate) -> ()){
      _ringReminderListen = listen
   }
   ///otify the distribution of GPS data
   public func sportGpsListen(listen:@escaping (_ model:protocol_exercise_gps_info) -> ()){
      _sportGpsListen = listen
   }
   
   public func setSportGPS(model:GPSModel, success:@escaping successBase,failure:@escaping failureArgument){
      serialQueue.sync {
         requestId+=1
         successDic["setSportGps\(requestId)"] = success;
         failureArgumentDic["setSportGps\(requestId)"] = failure
         let json = try? JSONEncoder().encode(model)
         if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("setSportGps\(requestId)", arguments: str)
         }
      }
   }
   
   public func getAfPpgUploadStatus(model:@escaping afPpgClosure) {
      serialQueue.sync {
         requestId+=1
         afPpgClosureDic["getAfPpgUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getAfPpgUploadStatus\(requestId)", arguments: "")
      }
   }
   
   public func getAfUploadStatus(model:@escaping afClosure) {
      serialQueue.sync {
         requestId+=1
         afClosureDic["getAfUploadStatus\(requestId)"] = model
         methodChannel?.invokeMethod("getAfUploadStatus\(requestId)", arguments: "")
      }
   }
   
   public func startMeasure(type:ring_health_type,model:@escaping clickHealthMeasureBase,failure:@escaping commonErrorBase){
      serialQueue.sync {
         requestId+=1
         clickHealthMeasureDic["successstartMeasure\(requestId)"] = model
         commonErrorBaseDic["failurestartMeasure\(requestId)"] = failure
         methodChannel?.invokeMethod("startMeasure\(requestId)", arguments: type.rawValue)
      }
   }
   
   public func stopMeasure(type:ring_health_type){
      methodChannel?.invokeMethod("stopMeasure", arguments: type.rawValue)
   }
   
   
   public func getQrCodeList(model: @escaping qrCodeListBase, failure: @escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         let methodName = "getQrCodeList\(requestId)"
         qrCodeListBaseDic[methodName] = model
         failureArgumentDic[methodName] = failure
         methodChannel?.invokeMethod(methodName, arguments: "")
      }
   }
   
   public func setQrCodeList(model:protocol_qr_code_list_operate,success:@escaping successBase,failure:@escaping failureArgument) {
      serialQueue.sync {
         requestId+=1
         successDic["setQrCodeList\(requestId)"] = success;
         failureArgumentDic["setQrCodeList\(requestId)"] = failure
         do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setQrCodeList\(requestId)", arguments: data)
         }catch{
            
         }
      }
   }
   
   public func cancelUploadTask(){
      methodChannel?.invokeMethod("cancelUploadTask", arguments: "")
   }
   
   
   public func delDeviceListen(model:@escaping (_ model:String) -> ()) {
      _delDeviceListen = model
   }
   
}
