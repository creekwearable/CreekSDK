//
//  CreekSDKExtension.swift
//  CreekSDK
//
//  Created by bean on 2023/7/15.
//

import Foundation

extension CreekSDK{
    
    ///MARK : initialization SDK
    public func initSDK() {
        methodChannel?.invokeMethod("initSDK", arguments: "")
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
        requestId+=1
        devicesBackDic["scanBase\(requestId)"] = devices
        endScanDic["endScan\(requestId)"] = endScan
        methodChannel?.invokeMethod("scanBase\(requestId)", arguments: timeOut)
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
    
    ///MARK : connect
    /// - Parameter :
    ///      - id :  DeviceModel.id
    ///      - connect :   call back connect state   true false
    /// - Returns:
    public func scanConnect(id:String,device:@escaping deviceBack,failure:@escaping failureArgument) {
        requestId+=1
        deviceBackDic["scanConnect\(requestId)"] = device
        failureArgumentDic["scanConnect\(requestId)"] = failure
        methodChannel?.invokeMethod("scanConnect\(requestId)", arguments: id)
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
        requestId+=1
        successDic["disconnect\(requestId)"] = success;
        failureArgumentDic["disconnect\(requestId)"] = failure
        methodChannel?.invokeMethod("disconnect\(requestId)", arguments: "")
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
        firmwareDic["getFirmware\(requestId)"] = model
        failureArgumentDic["getFirmware\(requestId)"] = failure
        methodChannel?.invokeMethod("getFirmware\(requestId)", arguments: "")
    }
    public func getSNFirmware(model:protocol_device_info,sn:@escaping SNFirmwareBase) {
        requestId+=1
        SNFirmwareDic["getSNFirmware\(requestId)"] = sn
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("getSNFirmware\(requestId)", arguments: data)
        }catch{
       
        }
    }
    ///MARK :Sync health data
    /// - Parameter :
    ///      - syncProgress: sync progress
    /// - Returns:
    public func sync(syncProgress:@escaping progressBase, syncSuccess:@escaping successBase, syncFailure:@escaping failureBase) {
        requestId+=1
        progressDic["syncBase\(requestId)"] = syncProgress
        successDic["syncBase\(requestId)"] = syncSuccess;
        failureDic["syncBase\(requestId)"] = syncFailure
        methodChannel?.invokeMethod("syncBase\(requestId)", arguments: "")
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
    
    ///MARK :Monitor the status of connected devices
    /// - Parameter :
    ///      - listenDeviceState：
    /// - Returns:
    public func listenDeviceState(listenDeviceState:@escaping (_ status:connectionStatus,_ deviceName:String)->()) {
        _listenDeviceState = listenDeviceState
    }
    
    ///MARK :Device bluetooth status
    /// - Parameter :
    ///      - model: call back protocol_connect_status_inquire_reply
    /// - Returns:
  public func bluetoothStatus(model:@escaping bluetoothStatusBase,failure:@escaping failureArgument) {
      requestId+=1
      bluetoothStatusDic["bluetoothStatus\(requestId)"] = model
      failureArgumentDic["bluetoothStatus\(requestId)"] = failure
      methodChannel?.invokeMethod("bluetoothStatus\(requestId)", arguments: "")
    }
    
    ///MARK :retrigger bt connect
    /// - Parameter :
    ///      - reconnect ： true false
    /// - Returns:
    public func firmwareReconnect(reconnect:Bool,success:@escaping successBase,failure:@escaping failureArgument) {
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
    ///MARK :Synchronize phone time to firmware
    public func syncTime(success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["syncTime\(requestId)"] = success;
        failureArgumentDic["syncTime\(requestId)"] = failure
        methodChannel?.invokeMethod("syncTime\(requestId)", arguments: "")
        
    }
    ///MARK :Get firmware time
    /// - Parameter :
    ///      - model：call back protocol_device_time_inquire_reply
    /// - Returns:
    public func getTime(model:@escaping timeBase,failure:@escaping failureArgument) {
        requestId+=1
        timeDic["getTime\(requestId)"] = model
        failureArgumentDic["getTime\(requestId)"] = failure
        methodChannel?.invokeMethod("getTime\(requestId)", arguments: "")
    }
    
    ///MARK :get Language
    /// - Parameter :
    ///      - model：call back protocol_language_inquire_reply
    /// - Returns:
    public func getLanguage(model:@escaping languageBase,failure:@escaping failureArgument) {
        requestId+=1
        languageDic["getLanguage\(requestId)"] = model
        failureArgumentDic["getLanguage\(requestId)"] = failure
        methodChannel?.invokeMethod("getLanguage\(requestId)", arguments: "")
    }
    
    ///MARK : set Language
    /// - Parameter :
    ///      - type：language
    /// - Returns:
    public func setLanguage(type:language,success:@escaping successBase,failure:@escaping failureArgument) {
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
    public func bindingDevice(bindType:BindType,id:String?,code:String?,success:@escaping successBase,failure:@escaping failureBase) {
        requestId+=1
        successDic["bindDevice\(requestId)"] = success;
        failureDic["bindDevice\(requestId)"] = failure
       
        let dic:[String:Any?] = ["bindType":bindType.rawValue,"address":id,"pairCode":code]
        do{
          let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0))
          if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
              methodChannel?.invokeMethod("bindDevice\(requestId)", arguments: JSONString)
          }
        }catch{
           print("Error converting string to dictionary: \(error.localizedDescription)")
        }
    }
    
    ///MARK :Get firmware user information and preferences
    /// - Parameter :
    ///      - model：call back protocol_user_info_operate
    /// - Returns:
    public func getUserInfo(model:@escaping userBase,failure:@escaping failureArgument) {
        requestId+=1
        userDic["getUserInfo\(requestId)"] = model
        failureArgumentDic["getUserInfo\(requestId)"] = failure
        methodChannel?.invokeMethod("getUserInfo\(requestId)", arguments: "")
    }
    
    ///MARK :Set firmware user information and preferences
    /// - Parameter :
    ///      - model: protocol_user_info_operate
    /// - Returns:
    public func setUserInfo(model:protocol_user_info_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setUserInfo\(requestId)"] = success;
        failureArgumentDic["setUserInfo\(requestId)"] = failure
        do{
            var operate =  protocol_user_info_inquire_reply()
            operate.goalSetting = model.goalSetting
            operate.personalInfo = model.personalInfo
            operate.preferences = model.preferences
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
    
    ///MARK :Get an alarm clock
    /// - Parameter :
    ///      - model：call back protocol_alarm_inquire_reply
    /// - Returns:
    public func getAlarm(model:@escaping alarmBase,failure:@escaping failureArgument) {
        requestId+=1
        alarmDic["getAlarm\(requestId)"] = model
        failureArgumentDic["getAlarm\(requestId)"] = failure
        methodChannel?.invokeMethod("getAlarm\(requestId)", arguments: "")
    }
    
    ///MARK :set an alarm
    /// - Parameter :
    ///      - model ：protocol_alarm_operate
    /// - Returns:
    public func setAlarm(model:protocol_alarm_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setAlarm\(requestId)"] = success;
        failureArgumentDic["setAlarm\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setAlarm\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Get do not disturb
    /// - Parameter :
    ///      - model：call back protocol_disturb_inquire_reply
    /// - Returns:protocol_alarm_inquire_reply
    public func getDisturb(model:@escaping disturbBase,failure:@escaping failureArgument) {
        requestId+=1
        disturbDic["getDisturb\(requestId)"] = model
        failureArgumentDic["getDisturb\(requestId)"] = failure
        methodChannel?.invokeMethod("getDisturb\(requestId)", arguments: "")
    }
    
    ///MARK :Set do not disturb
    /// - Parameter :
    ///      - model: protocol_disturb_operate
    /// - Returns:
    public func setDisturb(model:protocol_disturb_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setDisturb\(requestId)"] = success;
        failureArgumentDic["setDisturb\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setDisturb\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Get screen brightness
    /// - Parameter :
    ///      - model:call back protocol_screen_brightness_inquire_reply
    /// - Returns:
    public func getScreen(model:@escaping screenBase,failure:@escaping failureArgument) {
        requestId+=1
        screenDic["getScreen\(requestId)"] = model
        failureArgumentDic["getScreen\(requestId)"] = failure
        methodChannel?.invokeMethod("getScreen\(requestId)", arguments: "")
    }
    
    ///MARK :Screen Brightness Settings
    /// - Parameter :
    ///      - model: protocol_screen_brightness_operate
    /// - Returns:
    public func setScreen(model:protocol_screen_brightness_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setScreen\(requestId)"] = success;
        failureArgumentDic["setScreen\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setScreen\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Health Monitoring Acquisition
    /// - Parameter :
    ///      - operate: protocol_health_monitor_operate
    ///      - model : call back protocol_health_monitor_inquire_reply
    /// - Returns:
    public func getMonitor(operate:protocol_health_monitor_operate,model:@escaping monitorBase,failure:@escaping failureArgument) {
        requestId+=1
        monitorDic["getMonitor\(requestId)"] = model
        failureArgumentDic["getMonitor\(requestId)"] = failure
        do{
            let data = try operate.serializedData()
            methodChannel?.invokeMethod("getMonitor\(requestId)", arguments: data)
        }catch{
       
        }
       
    }
    
    ///MARK :Health Monitoring Settings
    /// - Parameter :
    ///      - model :protocol_health_monitor_operate
    /// - Returns:
    public func setMonitor(model:protocol_health_monitor_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setMonitor\(requestId)"] = success;
        failureArgumentDic["setMonitor\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMonitor\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Sleep Monitoring Acquisition
    /// - Parameter :
    ///      - model: protocol_sleep_monitor_inquire_reply
    /// - Returns:
    public func getSleepMonitor(model:@escaping sleepMonitorBase,failure:@escaping failureArgument) {
        requestId+=1
        sleepMonitorDic["getSleepMonitor\(requestId)"] = model
        failureArgumentDic["getSleepMonitor\(requestId)"] = failure
        methodChannel?.invokeMethod("getSleepMonitor\(requestId)", arguments: "")
       
    }
    
    ///MARK :Sleep Monitoring Settings
    /// - Parameter :
    ///      - model：protocol_sleep_monitor_operate
    /// - Returns:
    public func setSleepMonitor(model:protocol_sleep_monitor_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSleepMonitor\(requestId)"] = success;
        failureArgumentDic["setSleepMonitor\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSleepMonitor\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
//    ///MARK :drink water reminder
//    /// - Parameter :
//    ///      - model：protocol_drink_water_inquire_reply
//    /// - Returns:
//    public func getWater(model:@escaping ((_ model:protocol_drink_water_inquire_reply) -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
//        water = model
//        failureArgumentDic["getWater"] = failure
//        methodChannel?.invokeMethod("getWater", arguments: "")
//
//    }
//
//    ///MARK ::drink water Settings
//    /// - Parameter :
//    ///      - model:protocol_drink_water_operate
//    /// - Returns:
//    public func setWater(model:protocol_drink_water_operate,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
//        successDic["setWater"] = success;
//        failureArgumentDic["setWater"] = failure
//        do{
//            let data = try model.serializedData()
//            methodChannel?.invokeMethod("setWater", arguments: data)
//        }catch{
//
//        }
//    }
    

    public func getFindPhoneWatch(model:@escaping findPhoneWatchBase,failure:@escaping failureArgument) {
        requestId+=1
        findPhoneWatchDic["getFindPhoneWatch\(requestId)"] = model
        failureArgumentDic["getFindPhoneWatch\(requestId)"] = failure
        methodChannel?.invokeMethod("getFindPhoneWatch\(requestId)", arguments: "")
    }
    

    public func setFindPhoneWatch(model:protocol_find_phone_watch_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setFindPhoneWatch\(requestId)"] = success;
        failureArgumentDic["setFindPhoneWatch\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setFindPhoneWatch\(requestId)", arguments: data)
        }catch{

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
        requestId+=1
        worldTimeDic["getWorldTime\(requestId)"] = model
        failureArgumentDic["getWorldTime\(requestId)"] = failure
        methodChannel?.invokeMethod("getWorldTime\(requestId)", arguments: "")
       
    }
    
    ///MARK :world clock setting
    /// - Parameter :
    ///      - model ：protocol_world_time_operate
    /// - Returns:
    public func setWorldTime(model:protocol_world_time_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setWorldTime\(requestId)"] = success;
        failureArgumentDic["setWorldTime\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWorldTime\(requestId)", arguments: data)
        }catch{
       
        }
    }
    

//    public func getStanding(model:@escaping ((_ model:protocol_standing_remind_inquire_reply) -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
//        standing = model
//        failureArgumentDic["getStanding"] = failure
//        methodChannel?.invokeMethod("getStanding", arguments: "")
//
//    }
//
//
//    public func setStanding(model:protocol_standing_remind_operate,success:@escaping (() -> ()),failure:@escaping ((_ code:Int,_ message:String) -> ())) {
//        successDic["setStanding"] = success;
//        failureArgumentDic["setStanding"] = failure
//        do{
//            let data = try model.serializedData()
//            methodChannel?.invokeMethod("setStanding", arguments: data)
//        }catch{
//
//        }
//    }
    

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
        requestId+=1
        messageOnOffDic["getMessageOnOff\(requestId)"] = model
        failureArgumentDic["getMessageOnOff\(requestId)"] = failure
        methodChannel?.invokeMethod("getMessageOnOff\(requestId)", arguments: "")
       
    }
    
    ///MARK :message switch settings
    /// - Parameter :
    ///      - model ：protocol_message_notify_switch
    /// - Returns:
    public func setMessageOnOff(model:protocol_message_notify_switch,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setMessageOnOff\(requestId)"] = success;
        failureArgumentDic["setMessageOnOff\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMessageOnOff\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :music control
    /// - Parameter :
    ///      - model ：protocol_music_control_operate
    /// - Returns:
    public func setMusic(model:protocol_music_control_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setMusic\(requestId)"] = success;
        failureArgumentDic["setMusic\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMusic\(requestId)", arguments: data)
        }catch{

        }
    }
    
    ///MARK :set weather
    /// - Parameter :
    ///      - model: protocol_weather_operate
    /// - Returns:
    public func setWeather(model:protocol_weather_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setWeather\(requestId)"] = success;
        failureArgumentDic["setWeather\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWeather\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    
    ///MARK :Incoming call configuration query
    /// - Parameter :
    ///      - model : call back protocol_call_switch_inquire_reply
    /// - Returns:protocol_alarm_inquire_reply
    public func getCall(model:@escaping callBase,failure:@escaping failureArgument) {
        requestId+=1
        callDic["getCall\(requestId)"] = model
        failureArgumentDic["getCall\(requestId)"] = failure
        methodChannel?.invokeMethod("getCall\(requestId)", arguments: "")
       
    }
    
    ///MARK :caller configuration settings
    /// - Parameter :
    ///      - model : protocol_call_switch
    /// - Returns:
    public func setCall(model:protocol_call_switch,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setCall\(requestId)"] = success;
        failureArgumentDic["setCall\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setCall\(requestId)", arguments: data)
        }catch{
       
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
        requestId+=1
        contactsDic["getContacts\(requestId)"] = model
        failureArgumentDic["getContacts\(requestId)"] = failure
        methodChannel?.invokeMethod("getContacts\(requestId)", arguments: "")
       
    }
    
    ///MARK :contact settings
    /// - Parameter :
    ///      - model ：protocol_frequent_contacts_operate
    /// - Returns:
    public func setContacts(model:protocol_frequent_contacts_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setContacts\(requestId)"] = success;
        failureArgumentDic["setContacts\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setContacts\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Get quick card
    /// - Parameter :
    /// - Returns:
    public func getCard(model:@escaping cardBase,failure:@escaping failureArgument) {
        requestId+=1
        cardDic["getCard\(requestId)"] = model
        failureArgumentDic["getCard\(requestId)"] = failure
        methodChannel?.invokeMethod("getCard\(requestId)", arguments: "")

    }
    
    ///MARK :Set up quick cards
    /// - Parameter :
    ///           -model : protocol_quick_card_operate
    /// - Returns:
    public func setCard(model:protocol_quick_card_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setCard\(requestId)"] = success;
        failureArgumentDic["setCard\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setCard\(requestId)", arguments: data)
        }catch{

        }
    }
    
    ///MARK :Set do not disturb
    /// - Parameter :
    ///      - protocol_disturb_operate
    /// - Returns:
    public func setSportHeartRate(model:protocol_exercise_heart_rate_zone,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSportHeartRate\(requestId)"] = success;
        failureArgumentDic["setSportHeartRate\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportHeartRate\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Obtain the type of movement supported by the device
    /// - Parameter :
    ///      - model ：protocol_exercise_sporting_param_sort_inquire_reply
    /// - Returns:
    public func getSportType(model:@escaping sportTypeBase,failure:@escaping failureArgument) {
        requestId+=1
        sportTypeDic["getSportType\(requestId)"] = model
        failureArgumentDic["getSportType\(requestId)"] = failure
        methodChannel?.invokeMethod("getSportType\(requestId)", arguments: "")
       
    }
    
    ///MARK :Equipment motion arrangement order setting
    /// - Parameter :
    ///      - model ：protocol_exercise_sport_mode_sort
    /// - Returns:
    public func setSportSort(model:protocol_exercise_sport_mode_sort,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSportSort\(requestId)"] = success;
        failureArgumentDic["setSportSort\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportSort\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Query the sequence of equipment movement
    /// - Parameter :
    ///      - model ： call back protocol_exercise_sport_mode_sort_inquire_reply
    /// - Returns:protocol_alarm_inquire_reply
    public func getSportSort(model:@escaping sportSortBase,failure:@escaping failureArgument) {
        requestId+=1
        sportSortDic["getSportSort\(requestId)"] = model
        failureArgumentDic["getSportSort\(requestId)"] = failure
        methodChannel?.invokeMethod("getSportSort\(requestId)", arguments: "")
       
    }
    
    ///MARK :Child item data setting in sports
    /// - Parameter :
    ///      - model: protocol_exercise_sporting_param_sort
    /// - Returns:
    public func setSportSub(model:protocol_exercise_sporting_param_sort,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSportSub\(requestId)"] = success;
        failureArgumentDic["setSportSub\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportSub\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Data acquisition of children in sports
    /// - Parameter :
    ///      - model：call back protocol_exercise_sporting_param_sort_inquire_reply
    /// - Returns:protocol_alarm_inquire_reply
    public func getSportSub(model:@escaping sportSubBase,failure:@escaping failureArgument) {
        requestId+=1
        sportSubDic["getSportSub\(requestId)"] = model
        failureArgumentDic["getSportSub\(requestId)"] = failure
        methodChannel?.invokeMethod("getSportSub\(requestId)", arguments: "")
       
    }
    
    
    ///MARK :Sports self-recognition settings
    /// - Parameter :
    ///      - model : protocol_exercise_intelligent_recognition
    /// - Returns:
    public func setSportIdentification(model:protocol_exercise_intelligent_recognition,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSportIdentification\(requestId)"] = success;
        failureArgumentDic["setSportIdentification\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSportIdentification\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Sports self-identification query
    /// - Parameter :
    ///      - model : call back protocol_exercise_intelligent_recognition_inquire_reply
    /// - Returns:
    public func getSportIdentification(model:@escaping sportIdentificationBase,failure:@escaping failureArgument) {
        requestId+=1
        sportIdentificationDic["getSportIdentification\(requestId)"] = model
        failureArgumentDic["getSportIdentification\(requestId)"] = failure
        methodChannel?.invokeMethod("getSportIdentification\(requestId)", arguments: "")
       
    }
    
    
    ///MARK :set dial
    /// - Parameter :
    ///      - model : protocol_watch_dial_plate_operate
    /// - Returns:
    public func setWatchDial(model:protocol_watch_dial_plate_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setWatchDial\(requestId)"] = success;
        failureArgumentDic["setWatchDial\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setWatchDial\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Remove dial
    /// - Parameter :
    ///      - model : protocol_watch_dial_plate_operate
    /// - Returns:
    public func delWatchDial(model:protocol_watch_dial_plate_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["delWatchDial\(requestId)"] = success;
        failureArgumentDic["delWatchDial\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("delWatchDial\(requestId)", arguments: data)
        }catch{
       
        }
    }
    
    ///MARK :Query dial
    /// - Parameter :
    ///      - model : call back protocol_watch_dial_plate_operate
    /// - Returns:
    public func getWatchDial(model:@escaping watchDialBase,failure:@escaping failureArgument) {
        requestId+=1
        watchDialDic["getWatchDial\(requestId)"] = model
        failureArgumentDic["getWatchDial\(requestId)"] = failure
        methodChannel?.invokeMethod("getWatchDial\(requestId)", arguments: "")
       
    }
    
    ///MARK :Firmware Settings
    /// - Parameter :
    ///      - type ：1 Restart operation 2 Shut down operation
    /// - Returns:
    public func setSystem(type:Int,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSystem\(requestId)"] = success;
        failureArgumentDic["setSystem\(requestId)"] = failure
        methodChannel?.invokeMethod("setSystem\(requestId)", arguments: type)
    }
    
    
    ///MARK :Get quick card
    /// - Parameter :
    /// - Returns:
    public func getHotKey(model:@escaping hotKeyBase,failure:@escaping failureArgument) {
        requestId+=1
        hotKeyDic["getHotKey\(requestId)"] = model
        failureArgumentDic["getHotKey\(requestId)"] = failure
        methodChannel?.invokeMethod("getHotKey\(requestId)", arguments: "")

    }
    
    ///MARK :Set up quick cards
    /// - Parameter :
    ///           -model : protocol_quick_card_operate
    /// - Returns:
    public func setHotKey(model:protocol_button_crown_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setHotKey\(requestId)"] = success;
        failureArgumentDic["setHotKey\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setHotKey\(requestId)", arguments: data)
        }catch{

        }
    }
    
    ///MARK :Get menu
    /// - Parameter :
    /// - Returns:
    public func getTable(model:@escaping tableBase,failure:@escaping failureArgument) {
        requestId+=1
        tableDic["getTable\(requestId)"] = model
        failureArgumentDic["getTable\(requestId)"] = failure
        methodChannel?.invokeMethod("getTable\(requestId)", arguments: "")

    }
    
    ///MARK :Get emergency contacts
    /// - Parameter :
    /// - Returns:
    public func getContactsSOS(model:@escaping sosContactsBase,failure:@escaping failureArgument) {
        requestId+=1
        sosContactsDic["getSOSContacts\(requestId)"] = model
        failureArgumentDic["getSOSContacts\(requestId)"] = failure
        methodChannel?.invokeMethod("getSOSContacts\(requestId)", arguments: "")

    }
    
    ///MARK :Emergency contact settings
    /// - Parameter :
    ///           -model : protocol_emergency_contacts_operate
    /// - Returns:
    public func setContactsSOS(model:protocol_emergency_contacts_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setSOSContacts\(requestId)"] = success;
        failureArgumentDic["setSOSContacts\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setSOSContacts\(requestId)", arguments: data)
        }catch{

        }
    }
    
    public func getMenstrual(model:@escaping menstrualBase,failure:@escaping failureArgument) {
        requestId+=1
        menstrualDic["getMenstrual\(requestId)"] = model
        failureArgumentDic["getMenstrual\(requestId)"] = failure
        methodChannel?.invokeMethod("getMenstrual\(requestId)", arguments: "")
    }
    

    public func setMenstrual(model:protocol_menstruation_operate,success:@escaping successBase,failure:@escaping failureArgument) {
        requestId+=1
        successDic["setMenstrual\(requestId)"] = success;
        failureArgumentDic["setMenstrual\(requestId)"] = failure
        do{
            let data = try model.serializedData()
            methodChannel?.invokeMethod("setMenstrual\(requestId)", arguments: data)
        }catch{

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
        requestId+=1
        activitysClosureDic["getActivityNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getActivityNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    
    ///MARK :Get Sleep Health Data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getSleepNewTimeData(startTime:String,endTime:String,model:@escaping sleepsClosure) {
        requestId+=1
        sleepsClosureDic["getSleepNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getSleepNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    ///MARK :Get Heart Rate Health Data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getHeartRateNewTimeData(startTime:String,endTime:String,model:@escaping heartRatesClosure) {
        requestId+=1
        heartRatesClosureDic["getHeartRateNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getHeartRateNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    ///MARK :Get Stress Health Data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getStressNewTimeData(startTime:String,endTime:String,model:@escaping stresssClosure) {
        requestId+=1
        stresssClosureDic["getStressNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getStressNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    ///MARK :Get Noise Health Data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getNoiseNewTimeData(startTime:String,endTime:String,model:@escaping noisesClosure) {
        requestId+=1
        noisesClosureDic["getNoiseNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getNoiseNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    ///MARK :Obtain blood oxygen health data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getSpoNewTimeData(startTime:String,endTime:String,model:@escaping oxygensClosure) {
        requestId+=1
        oxygensClosureDic["getSpoNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getSpoNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    
    ///MARK :Get all motion data by type
    /// - Parameter :
    ///        - type : nil query all type
    /// - Returns:
    public func getSportRecord(_ type:SportType?,model:@escaping sportsClosure) {
        requestId+=1
        sportsClosureDic["getSportRecord\(requestId)"] = model
        methodChannel?.invokeMethod("getSportRecord\(requestId)", arguments: type?.rawValue ?? 1000)
    }
    
    ///MARK :Get sport details
    /// - Parameter :
    ///         -id：SportModel.id
    /// - Returns:
    public func getSportDetails(id:Int?,model:@escaping sportClosure) {
        requestId+=1
        sportClosureDic["getSportDetails\(requestId)"] = model
        methodChannel?.invokeMethod("getSportDetails\(requestId)", arguments: id)
    }
    
    ///MARK :Query sports data by time range and type
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    ///      - type : nil query all type
    /// - Returns:
    public func getSportTimeData(startTime:String,endTime:String,_ type:SportType?,model:@escaping sportsClosure) {
        requestId+=1
        sportsClosureDic["getSportTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getSportTimeData\(requestId)", arguments: [startTime ,endTime,type?.rawValue ?? 1000] as [Any])
    }
    
    ///MARK:  Delete a piece of exercise data
    /// - Parameter :
    ///    id:SportModel.id
    /// - Returns:
    public func delSportRecord(id:Int,model:@escaping baseClosure) {
        requestId+=1
        baseClosureDic["delSportRecord\(requestId)"] = model
        methodChannel?.invokeMethod("delSportRecord\(requestId)", arguments: id)
    }
    
    ///MARK :Get HRV Health Data
    /// - Parameter :
    ///      - startTime   2023-08-03
    ///      - endTime    2023-08-03
    /// - Returns:
    public func getHrvNewTimeData(startTime:String,endTime:String,model:@escaping hrvsClosure) {
        requestId+=1
        hrvsClosureDic["getHrvNewTimeData\(requestId)"] = model
        methodChannel?.invokeMethod("getHrvNewTimeData\(requestId)", arguments: [startTime ,endTime])
    }
    
    ///MARK :Get all bound devices
    /// - Parameter :
    /// - Returns:
    public func getBindDevice(model:@escaping devicesBack) {
        requestId+=1
        devicesBackDic["getBindDevice\(requestId)"] = model
        methodChannel?.invokeMethod("getBindDevice\(requestId)", arguments: "")
    }
    
    ///*******************************
    ///Query unuploaded data
    ///*******************************

    public func getSportUploadStatus(model:@escaping sportsClosure) {
        requestId+=1
        sportsClosureDic["getSportUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getSportUploadStatus\(requestId)", arguments: "")
    }
    
    public func getActivityUploadStatus(model:@escaping activitysClosure) {
        requestId+=1
        activitysClosureDic["getActivityUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getActivityUploadStatus\(requestId)", arguments: "")
    }
    
    public func getHeartRateUploadStatus(model:@escaping heartRatesClosure) {
        requestId+=1
        heartRatesClosureDic["getHeartRateUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getHeartRateUploadStatus\(requestId)", arguments: "")
    }
    
    public func getHrvUploadStatus(model:@escaping hrvsClosure) {
        requestId+=1
        hrvsClosureDic["getHrvUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getHrvUploadStatus\(requestId)", arguments: "")
    }
    
    public func getNoiseUploadStatus(model:@escaping noisesClosure) {
        requestId+=1
        noisesClosureDic["getNoiseUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getNoiseUploadStatus\(requestId)", arguments: "")
    }
    public func getStressUploadStatus(model:@escaping stresssClosure) {
        requestId+=1
        stresssClosureDic["getStressUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getStressUploadStatus\(requestId)", arguments: "")
    }
    
    public func getSleepUploadDays(model:@escaping sleepsClosure) {
        requestId+=1
        sleepsClosureDic["getSleepUploadDays\(requestId)"] = model
        methodChannel?.invokeMethod("getSleepUploadDays\(requestId)", arguments: "")
    }
    
    public func getSpoUploadStatus(model:@escaping oxygensClosure) {
        requestId+=1
        oxygensClosureDic["getSpoUploadStatus\(requestId)"] = model
        methodChannel?.invokeMethod("getSpoUploadStatus\(requestId)", arguments: "")
    }
    
    public func setDBUser(_ userID:Int?) {
        methodChannel?.invokeMethod("setDBUser", arguments: userID ?? 1)
    }
    
    public func updateDBUploadStatus(_ type:SyncServerType) {
        methodChannel?.invokeMethod("updateDBUploadStatus", arguments: type.rawValue)
    }
    
    public func rawQueryDB(_ sql:String,model:@escaping rawQueryDBClosure) {
        requestId+=1
        rawQueryDBClosureDic["rawQueryDB\(requestId)"] = model
        methodChannel?.invokeMethod("rawQueryDB\(requestId)", arguments: sql)
    }
    
    public func encodeOnlineFile(_ ephemerisModel :EphemerisModel,model:@escaping ephemerisData,failure:@escaping failureArgument){
        requestId+=1
        ephemerisClosureDic["encodeOnlineFile\(requestId)"] = model
        failureArgumentDic["encodeOnlineFile\(requestId)"] = failure
        let json = try? JSONEncoder().encode(ephemerisModel)
        if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodeOnlineFile\(requestId)", arguments: str)
        }
    }
    
    public func encodeOfflineFile(_ ephemerisModel :EphemerisModel,model:@escaping ephemerisData,failure:@escaping failureArgument){
        requestId+=1
        ephemerisClosureDic["encodeOfflineFile\(requestId)"] = model
        failureArgumentDic["encodeOfflineFile\(requestId)"] = failure
        let json = try? JSONEncoder().encode(ephemerisModel)
        if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodeOfflineFile\(requestId)", arguments: str)
        }
    }
    
    public func encodePhoneFile(_ phoneModel :[PhoneModel],model:@escaping ephemerisData,failure:@escaping failureArgument){
        requestId+=1
        ephemerisClosureDic["encodePhoneFile\(requestId)"] = model
        failureArgumentDic["encodePhoneFile\(requestId)"] = failure
        let json = try? JSONEncoder().encode(phoneModel)
        if let data = json, let str = String(data: data, encoding: .utf8) {
            methodChannel?.invokeMethod("encodePhoneFile\(requestId)", arguments: str)
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
        requestId+=1
        parseDialClosureDic["parseDial\(requestId)"] = model
        methodChannel?.invokeMethod("parseDial\(requestId)", arguments: [path,width,height,radius,platformType.rawValue])
    }
    
    ///Get the watch face generated image
    public func getPreviewImage(model:@escaping previewImageBase) {
        requestId+=1
        previewImageClosureDic["getPreviewImage\(requestId)"] = model
        methodChannel?.invokeMethod("getPreviewImage\(requestId)", arguments: "")
    }
    
    ///Set color
    public func setCurrentColor(selectIndex:Int,model:@escaping parseDialBase) {
        requestId+=1
        parseDialClosureDic["setCurrentColor\(requestId)"] = model
        methodChannel?.invokeMethod("setCurrentColor\(requestId)", arguments: selectIndex)
    }
    
    ///set background
    public func setCurrentBackgroundImagePath(selectIndex:Int,model:@escaping parseDialBase) {
        requestId+=1
        parseDialClosureDic["setCurrentBackgroundImagePath\(requestId)"] = model
        methodChannel?.invokeMethod("setCurrentBackgroundImagePath\(requestId)", arguments: selectIndex)
    }
    
    ///Set function
    public func setCurrentFunction(selectIndex:[Int],model:@escaping parseDialBase) {
        requestId+=1
        parseDialClosureDic["setCurrentFunction\(requestId)"] = model
        methodChannel?.invokeMethod("setCurrentFunction\(requestId)", arguments: selectIndex)
    }
    
    ///Generate watch face
    public func encodeDial(model:@escaping dialDataBase) {
        requestId+=1
        dialDataClosureDic["encodeDial\(requestId)"] = model
        methodChannel?.invokeMethod("encodeDial\(requestId)", arguments: "")
    }
    
    
    
    
}
