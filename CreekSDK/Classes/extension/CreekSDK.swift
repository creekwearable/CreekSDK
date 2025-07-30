//
//  CreekSDK.swift
//  CreekSDK
//
//  Created by bean on 2023/6/7.
//

import Foundation
import Flutter
import FlutterPluginRegistrant
import SwiftProtobuf

public typealias activitysClosure = (_ model:BaseModel<[ActivityModel]>) -> ()
public typealias heartRatesClosure = (_ model:BaseModel<[HeartRateModel]>) -> ()
public typealias stresssClosure = (_ model:BaseModel<[StressModel]>) -> ()
public typealias noisesClosure = (_ model:BaseModel<[NoiseModel]>) -> ()
public typealias oxygensClosure = (_ model:BaseModel<[OxygenModel]>) -> ()
public typealias sleepsClosure = (_ model:BaseModel<[SleepModel]>) -> ()
public typealias sportsClosure = (_ model:BaseModel<[SportModel]>) -> ()
public typealias hrvsClosure = (_ model:BaseModel<[HrvModel]>) -> ()
public typealias sportClosure = (_ model:BaseModel<SportModel>) -> ()
public typealias devicesBack = (_ model:[ScanDeviceModel]) -> ()
public typealias deviceBack = (_ model:ScanDeviceModel) -> ()
public typealias ephemerisData = (_ model:Data) -> ()
public typealias ContactsIconData = (_ model:Data) -> ()
public typealias progressBase = (_ progress:Int) -> ()
public typealias baseClosure = (_ model:BaseModel<BaseDataModel>) -> ()
public typealias successBase = () -> ()
public typealias failureBase = () -> ()
public typealias authorizationFailureBase = () -> ()
public typealias endScanBase = () -> ()
public typealias failureArgument = (_ code:Int,_ message:String) -> ()
public typealias firmwareBase = (_ model:protocol_device_info) -> ()
public typealias timeBase = (_ model:protocol_device_time_inquire_reply) -> ()
public typealias languageBase = (_ model:protocol_language_inquire_reply) -> ()
public typealias userBase = (_ model:protocol_user_info_operate) -> ()
public typealias alarmBase = (_ model:protocol_alarm_inquire_reply) -> ()
public typealias disturbBase = (_ model:protocol_disturb_inquire_reply) -> ()
public typealias screenBase = (_ model:protocol_screen_brightness_inquire_reply) -> ()
public typealias monitorBase = (_ model:protocol_health_monitor_inquire_reply) -> ()
public typealias sleepMonitorBase = (_ model:protocol_sleep_monitor_inquire_reply) -> ()
public typealias waterBase = (_ model:protocol_drink_water_inquire_reply) -> ()
public typealias findPhoneWatchBase = (_ model:protocol_find_phone_watch_inquire_reply) -> ()
public typealias voiceBase = (_ model:protocol_voice_assistant_inquire_reply) -> ()
public typealias worldTimeBase = (_ model:protocol_world_time_inquire_reply) -> ()
public typealias standingBase = (_ model:protocol_standing_remind_inquire_reply) -> ()
public typealias messageTypeBase = (_ model:protocol_message_notify_func_support_reply) -> ()
public typealias messageAppBase = (_ model:protocol_message_notify_data_inquire_reply) -> ()
public typealias messageOnOffBase = (_ model:protocol_message_notify_switch_inquire_reply) -> ()
public typealias callBase = (_ model:protocol_call_switch_inquire_reply) -> ()
public typealias contactsBase = (_ model:protocol_frequent_contacts_inquire_reply) -> ()
public typealias sosContactsBase = (_ model:protocol_emergency_contacts_inquire_reply) -> ()
public typealias cardBase = (_ model:protocol_quick_card_inquire_reply) -> ()
public typealias sportTypeBase = (_ model:protocol_exercise_func_support_reply) -> ()
public typealias sportSortBase = (_ model:protocol_exercise_sport_mode_sort_inquire_reply) -> ()
public typealias sportSubBase = (_ model:protocol_exercise_sporting_param_sort_inquire_reply) -> ()
public typealias sportIdentificationBase = (_ model:protocol_exercise_intelligent_recognition_inquire_reply) -> ()
public typealias watchDialBase = (_ model:protocol_watch_dial_plate_inquire_reply) -> ()
public typealias hotKeyBase = (_ model:protocol_button_crown_inquire_reply) -> ()
public typealias menstrualBase = (_ model:protocol_menstruation_inquire_reply) -> ()
public typealias focusBase = (_ model:protocol_focus_mode_inquire_reply) -> ()
public typealias tableBase = (_ model:protocol_function_table) -> ()
public typealias bluetoothStatusBase = (_ model:protocol_connect_status_inquire_reply) -> ()
public typealias appListBase = (_ model:protocol_app_list_inquire_reply) -> ()
public typealias eventTrackingBase = (_ model:protocol_event_tracking_inquire_reply) -> ()
public typealias rawQueryDBClosure = (_ jsonString:String) -> ()
public typealias SNFirmwareBase = (_ sn:String) -> ()
public typealias parseDialBase = (_ model:DialParseModel) -> ()
public typealias parsePhotoDialBase = (_ model:DialPhotoParseModel) -> ()
public typealias parseVideoDialBase = (_ model:DialVideoParseModel) -> ()
public typealias previewImageBase = (_ model:Data) -> ()
public typealias dialDataBase = (_ model:Data) -> ()
public typealias boolBase = (_ model:Bool) -> ()
public typealias valueBase = (_ model:Int) -> ()
public typealias upgradeStateBase = (_ model:UpgradeModel) -> ()
public typealias listenDeviceBase = (_ status:connectionStatus,_ deviceName:String)->()
public typealias gpsBase = () -> (EphemerisGPSModel)

public typealias calendarBase = (_ model:protocol_calendar_inquire_reply) -> ()
public typealias watchDirectionBase = (_ model:protocol_watch_direction_inquire_reply) -> ()
public typealias healthSnapshotBase = (_ model:protocol_health_snap_inquire_reply) -> ()
public typealias musicBase = (_ model:protocol_music_file_inquire_reply) -> ()
public typealias morningBase = (_ model:protocol_good_morning_inquire_reply) -> ()
public typealias courseBase = (_ model:protocol_exercise_course_list_inquire_reply) -> ()
public typealias geoBase = (_ model:protocol_geobin_inquire_reply) -> ()
public typealias geoAddressBase = (_ lat:Double,_ lon:Double) -> (String)
public typealias authorizationCodeBase = (_ code:String) -> ()
public typealias GPXBase = (_ model:Data) -> ()
public typealias watchSensorBase = (_ model:protocol_watch_sensors_inquire_reply) -> ()
public typealias waterAssistantBase = (_ model:protocol_water_assistant_inquire_reply) -> ()

public typealias firmwareUpdateBase = (_ model:firmware_update_response) -> ()

public typealias backStringBase = (_ str:String) -> ()



@objc open class CreekSDK: NSObject{
   
   public var connectStatus: connectionStatus = connectionStatus.none
   public static let instance = CreekSDK()
   var requestId:Int = 0
   var methodChannel : FlutterMethodChannel?
   var flutterEngine : FlutterEngine?
   var _noticeUpdateListen:((_ model:NoticeUpdateModel) -> ())?         //Firmware update notification
   var _eventReportListen:((_ model:EventReportModel) -> ())?           //Firmware reporting notification
   var _exceptionListen:((_ model:String) -> ())?                       //Bluetooth native logs
   var _listenDeviceState:((_ status:connectionStatus,_ deviceName:String)->())?   //Monitoring device
   var _bluetoothStateListen:((_ state:BluetoothState)->())?   //Monitoring device
   var _inTransitionDevice:((_ connectState:Bool)->())?
   var _queryConnectedDevice:((_ deviceId:String) ->())?
   var _connect:((_ connectState:Bool)->())?
   var _watchResetListen:(()->())?
   var SNFirmwareDic:[String:SNFirmwareBase] = [:]
   var endScanDic:[String:endScanBase] = [:]
   var deviceBackDic:[String:deviceBack] = [:]
   var devicesBackDic:[String:devicesBack] = [:]
   var progressDic:[String:progressBase] = [:] //Sync progress
   var successDic:[String:successBase] = [:]
   var authorizationFailureDic:[String:authorizationFailureBase] = [:]
   var failureDic:[String:failureBase] = [:]
   var failureArgumentDic:[String:failureArgument] = [:]
   var baseClosureDic:[String:baseClosure] = [:]
   var firmwareDic:[String:firmwareBase] = [:]
   var timeDic:[String:timeBase] = [:]
   var languageDic:[String:languageBase] = [:]           //Language
   var userDic:[String:userBase] = [:]       //User information preferences/settings
   var alarmDic:[String:alarmBase] = [:]      //Retrieve alarm
   var disturbDic:[String:disturbBase] = [:]      //Retrieve Do Not Disturb
   var screenDic:[String:screenBase] = [:]      //Screen capture
   var monitorDic:[String:monitorBase] = [:]      //Health monitoring
   var sleepMonitorDic:[String:sleepMonitorBase] = [:]     //Sleep monitoring
   var waterDic:[String:waterBase] = [:]      //Drink water reminder
   var findPhoneWatchDic:[String:findPhoneWatchBase] = [:]      //looking for watch
   var voiceDic:[String:voiceBase] = [:]
   var worldTimeDic:[String:worldTimeBase] = [:]      //world clock
   var standingDic:[String:standingBase] = [:]      //Stand reminder
   var messageTypeDic:[String:messageTypeBase] = [:]      //Get the message types supported by the device
   var messageAppDic:[String:messageAppBase] = [:]      //app message reminder
   var messageOnOffDic:[String:messageOnOffBase] = [:]
   var callDic:[String:callBase] = [:]                     //incoming call
   var contactsDic:[String:contactsBase] = [:]     //Frequent contacts
   var sosContactsDic:[String:sosContactsBase] = [:]      //emergency contact
   var cardDic:[String:cardBase] = [:]                 //Quick card
   var sportTypeDic:[String:sportTypeBase] = [:]       //Device supports sports types
   var sportSortDic:[String:sportSortBase] = [:]      //
   var sportSubDic:[String:sportSubBase] = [:]       //
   var sportIdentificationDic:[String:sportIdentificationBase] = [:]      //Motion self-recognition
   var watchDialDic:[String:watchDialBase] = [:]       //dial
   var hotKeyDic:[String:hotKeyBase] = [:]            //shortcut key
   var menstrualDic:[String:menstrualBase] = [:]           //women's health
   var focusDic:[String:focusBase] = [:]                //focus mode
   var tableDic:[String:tableBase] = [:]                           //Menu
   var appListDic:[String:appListBase] = [:]                           //app list
   var eventTrackingDic:[String:eventTrackingBase] = [:]
   var bluetoothStatusDic:[String:bluetoothStatusBase] = [:]
   var rawQueryDBClosureDic:[String:rawQueryDBClosure] = [:]
   var activitysClosureDic:[String:activitysClosure] = [:]
   var heartRatesClosureDic:[String:heartRatesClosure] = [:]
   var stresssClosureDic:[String:stresssClosure] = [:]
   var noisesClosureDic:[String:noisesClosure] = [:]
   var oxygensClosureDic:[String:oxygensClosure] = [:]
   var sleepsClosureDic:[String:sleepsClosure] = [:]
   var sportsClosureDic:[String:sportsClosure] = [:]
   var parseDialClosureDic:[String:parseDialBase] = [:]
   var parsePhotoDialClosureDic:[String:parsePhotoDialBase] = [:]
   var parseVideoDialClosureDic:[String:parseVideoDialBase] = [:]
   var previewImageClosureDic:[String:previewImageBase] = [:]
   var dialDataClosureDic:[String:dialDataBase] = [:]
   var sportClosureDic:[String:sportClosure] = [:]
   var hrvsClosureDic:[String:hrvsClosure] = [:]
   var ephemerisClosureDic:[String:ephemerisData] = [:]
   var contactsIconClosureDic:[String:ContactsIconData] = [:]
   var boolClosureDic:[String:boolBase] = [:]
   
   var valueClosureDic:[String:valueBase] = [:]
   var upgradeStateClosureDic:[String:upgradeStateBase] = [:]
   var listenDeviceClosureDic:[String:listenDeviceBase] = [:]
   var logPathClosure:((_ path:String) -> ())?
   var _gpsClosure:gpsBase?
   var _liveSportDataListen:((_ model:protocol_exercise_sync_realtime_info) -> ())?
   var _liveSportControlListen:((_ model:protocol_exercise_control_operate) -> ())?
   
   
   var calendarDic:[String:calendarBase] = [:]
   var watchDirectionDic:[String:watchDirectionBase] = [:]
   var healthSnapshotDic:[String:healthSnapshotBase] = [:]
   var musicDic:[String:musicBase] = [:]
   var morningDic:[String:morningBase] = [:]
   var courseDic:[String:courseBase] = [:]
   var geoDic:[String:geoBase] = [:]
   var _geoAddressClosure:geoAddressBase?
   var authorizationCodeDic:[String:authorizationCodeBase] = [:]
   var channelCompletedClosure:(()->())?
   var GPXDic:[String:GPXBase] = [:]
   var watchSensorDic:[String:watchSensorBase] = [:]
   var waterAssistantDic:[String:waterAssistantBase] = [:]
   var firmwareUpdateDic:[String:firmwareUpdateBase] = [:]
   var backStringBaseDic:[String:backStringBase] = [:]
   
   let serialQueue = DispatchQueue(label: "com.creek.serialQueue")
   
   public override init() {
      
      super.init()
   }
   
   public func setupInit(completed:(()->())? = nil){
      channelCompletedClosure = completed
      flutterEngine = FlutterEngine(name: "io.flutter", project: nil)
      flutterEngine?.run(withEntrypoint: nil)
      GeneratedPluginRegistrant.register(with: flutterEngine!)
      methodChannel = FlutterMethodChannel(name: "com.watchic.app/sdk",
                                           binaryMessenger: flutterEngine!.binaryMessenger)
      methodChannel?.setMethodCallHandler(handle(_:result:))
   }
   
   public func setup(withflutterEngine engine: FlutterEngine) {
      flutterEngine = engine
      methodChannel = FlutterMethodChannel(name: "com.watchic.app/sdk", binaryMessenger: flutterEngine!.binaryMessenger)
      methodChannel?.setMethodCallHandler(handle(_:result:))
      
   }
   
   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)  {
      print("ios\(call.method)")
      if(call.method.contains("scanBase")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel([ScanDeviceModel].self, dic){
                  if let back = devicesBackDic[call.method]{
                     back(model)
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
      }else if(call.method.contains("endScan")){
         if let back = endScanDic[call.method]{
            back()
            endScanDic.removeValue(forKey: call.method)
         }
      }else if(call.method.contains("scanConnect")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(ScanDeviceModel.self, dic){
                  if let back = deviceBackDic[call.method]{
                     back(model)
                     deviceBackDic.removeValue(forKey: call.method)
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
      }else if(call.method == "connect"){
         if let response = call.arguments as? Bool{
            if let connect = _connect{
               connect(response)
            }
         }
      }else if(call.method == "externalConnect"){
         if let response = call.arguments as? Bool{
            if let connect = _connect{
               connect(response)
            }
         }
      }else if(call.method == "inTransitionDevice"){
         if let response = call.arguments as? Bool{
            if let connect = _inTransitionDevice{
               connect(response)
            }
         }
         
      }else if(call.method.contains("getFirmware")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_device_info(serializedData: response.data,partial: true)
               if let back = firmwareDic[call.method]{
                  back(model)
                  firmwareDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }else if(call.method == "progress"){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let adic = dic as? NSDictionary{
                  let message = adic["message"] as? Int
                  let key = adic["key"] as? String
                  
                  if let response = key{
                     if let back =  progressDic[response]{
                        back(message ?? 0)
                     }
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
      }else if(call.method == "success"){
         if let response = call.arguments as? String{
            if let back =  successDic[response]{
               back()
               successDic.removeValue(forKey: response)
            }
         }
      }
      else if(call.method == "failure"){
         if let response = call.arguments as? String{
            if let back =  failureDic[response]{
               back()
               failureDic.removeValue(forKey: response)
            }
         }
      }
      else if(call.method == "authorizationFailure"){
         if let response = call.arguments as? String{
            if let back =  authorizationFailureDic[response]{
               back()
               authorizationFailureDic.removeValue(forKey: response)
            }
         }
      }
      else if(call.method == "failureArgument"){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let adic = dic as? NSDictionary{
                  let code = adic["code"] as? Int
                  let message = adic["message"] as? String
                  let key = adic["key"] as? String
                  
                  if let response = key{
                     if let back =  failureArgumentDic[response]{
                        back(code ?? 0,message ?? "")
                        failureArgumentDic.removeValue(forKey: response)
                     }
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
      }
      else if(call.method == "listenDeviceState"){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let adic = dic as? NSDictionary{
                  let state = adic["status"] as? Int
                  let deviceName = adic["deviceName"] as? String
                  let cStatus = getConnectionStatus(state ?? 0)
                  if(cStatus != .sync || cStatus != .syncComplete){
                     self.connectStatus = cStatus
                  }
                  if let listenDeviceState = _listenDeviceState{
                     listenDeviceState(cStatus, deviceName ?? "")
                  }
                  if !listenDeviceClosureDic.isEmpty {
                     listenDeviceClosureDic.forEach { (key: String, value: listenDeviceBase) in
                        value(cStatus, deviceName ?? "")
                     }
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
      }
      else if(call.method.contains("bluetoothStatus")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_connect_status_inquire_reply(serializedData: response.data,partial: true)
               if let back = bluetoothStatusDic[call.method]{
                  back(model)
                  bluetoothStatusDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getTime")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_device_time_inquire_reply(serializedData: response.data,partial: true)
               if let back = timeDic[call.method]{
                  back(model)
                  timeDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getLanguage")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_language_inquire_reply(serializedData: response.data,partial: true)
               if let back = languageDic[call.method]{
                  back(model)
                  languageDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getUserInfo")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_user_info_operate(serializedData: response.data,partial: true)
               if let user = userDic[call.method]{
                  user(model)
                  userDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getAlarm")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_alarm_inquire_reply(serializedData: response.data,partial: true)
               if let alarm = alarmDic[call.method]{
                  alarm(model)
                  alarmDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getDisturb")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_disturb_inquire_reply(serializedData: response.data,partial: true)
               if let back = disturbDic[call.method]{
                  back(model)
                  disturbDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getScreen")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_screen_brightness_inquire_reply(serializedData: response.data,partial: true)
               if let back = screenDic[call.method]{
                  back(model)
                  screenDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getMonitor")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_health_monitor_inquire_reply(serializedData: response.data,partial: true)
               if let back = monitorDic[call.method]{
                  back(model)
                  monitorDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getSleepMonitor")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_sleep_monitor_inquire_reply(serializedData: response.data,partial: true)
               if let back = sleepMonitorDic[call.method]{
                  back(model)
                  sleepMonitorDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getWater")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_drink_water_inquire_reply(serializedData: response.data,partial: true)
               if let back = waterDic[call.method]{
                  back(model)
                  waterDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getFindPhoneWatch")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_find_phone_watch_inquire_reply(serializedData: response.data,partial: true)
               if let back = findPhoneWatchDic[call.method]{
                  back(model)
                  findPhoneWatchDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
      }
      else if(call.method.contains("getVoice")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_voice_assistant_inquire_reply(serializedData: response.data,partial: true)
               if let back = voiceDic[call.method]{
                  back(model)
                  voiceDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
      }
      else if(call.method.contains("getWorldTime")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_world_time_inquire_reply(serializedData: response.data,partial: true)
               if let back = worldTimeDic[call.method]{
                  back(model)
                  worldTimeDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
      }
      else if(call.method.contains("getStanding")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_standing_remind_inquire_reply(serializedData: response.data,partial: true)
               if let back = standingDic[call.method]{
                  back(model)
                  standingDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getMessageType")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_message_notify_func_support_reply(serializedData: response.data,partial: true)
               if let back = messageTypeDic[call.method]{
                  back(model)
                  messageTypeDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
      }
      else if(call.method.contains("getMessageApp")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_message_notify_data_inquire_reply(serializedData: response.data,partial: true)
               if let back = messageAppDic[call.method]{
                  back(model)
                  messageAppDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
         
      }
      else if(call.method.contains("getMessageOnOff")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_message_notify_switch_inquire_reply(serializedData: response.data,partial: true)
               if let back = messageOnOffDic[call.method]{
                  back(model)
                  messageOnOffDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getCall")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_call_switch_inquire_reply(serializedData: response.data,partial: true)
               if let back = self.callDic[call.method]{
                  back(model)
                  callDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getContacts")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_frequent_contacts_inquire_reply(serializedData: response.data,partial: true)
               if let back = contactsDic[call.method]{
                  back(model)
                  contactsDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getCard")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_quick_card_inquire_reply(serializedData: response.data,partial: true)
               if let back = cardDic[call.method]{
                  back(model)
                  cardDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getSportIdentification")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_intelligent_recognition_inquire_reply(serializedData: response.data,partial: true)
               if let back = sportIdentificationDic[call.method]{
                  back(model)
                  sportIdentificationDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
      }
      else if(call.method.contains("getSportSub")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_sporting_param_sort_inquire_reply(serializedData: response.data,partial: true)
               if let back = sportSubDic[call.method]{
                  back(model)
                  sportSubDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
         
         
      }
      else if(call.method.contains("getSportSort")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_sport_mode_sort_inquire_reply(serializedData: response.data,partial: true)
               if let back = sportSortDic[call.method]{
                  back(model)
                  sportSortDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getSportType")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_func_support_reply(serializedData: response.data,partial: true)
               if let back = sportTypeDic[call.method]{
                  back(model)
                  sportTypeDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getWatchDial")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_watch_dial_plate_inquire_reply(serializedData: response.data,partial: true)
               if let back = watchDialDic[call.method]{
                  back(model)
                  watchDialDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getActivityNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[ActivityModel]>.self, dic){
                  
                  if let back = activitysClosureDic[call.method]{
                     back(model);
                     activitysClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSleepNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[SleepModel]>.self, dic){
                  if let back = sleepsClosureDic[call.method]{
                     back(model);
                     sleepsClosureDic.removeValue(forKey: call.method)
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getHeartRateNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[HeartRateModel]>.self, dic){
                  if let back = heartRatesClosureDic[call.method]{
                     back(model);
                     heartRatesClosureDic.removeValue(forKey: call.method)
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getStressNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[StressModel]>.self, dic){
                  if let back = stresssClosureDic[call.method]{
                     back(model);
                     stresssClosureDic.removeValue(forKey: call.method)
                  }
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getNoiseNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[NoiseModel]>.self, dic){
                  if let back = noisesClosureDic[call.method]{
                     back(model);
                     noisesClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSpoNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[OxygenModel]>.self, dic){
                  if let back = oxygensClosureDic[call.method]{
                     back(model);
                     oxygensClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSportRecord")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[SportModel]>.self, dic){
                  if let back = sportsClosureDic[call.method]{
                     back(model);
                     sportsClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSportDetails")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<SportModel>.self, dic){
                  if let back = sportClosureDic[call.method]{
                     back(model);
                     sportClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
         
      }
      else if(call.method.contains("getSportTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[SportModel]>.self, dic){
                  if let back = sportsClosureDic[call.method]{
                     back(model);
                     sportsClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
         
      }
      else if(call.method.contains("delSportRecord")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<BaseDataModel>.self, dic){
                  if let back = baseClosureDic[call.method]{
                     back(model);
                     baseClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getHrvNewTimeData")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[HrvModel]>.self, dic){
                  if let back = hrvsClosureDic[call.method]{
                     back(model);
                     hrvsClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getBindDevice")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel([ScanDeviceModel].self, dic){
                  if let back = devicesBackDic[call.method]{
                     back(model)
                     devicesBackDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
      }
      else if(call.method.contains("getHotKey")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_button_crown_inquire_reply(serializedData: response.data,partial: true)
               if let back = hotKeyDic[call.method]{
                  back(model)
                  hotKeyDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getMenstrual")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_menstruation_inquire_reply(serializedData: response.data,partial: true)
               if let back = menstrualDic[call.method]{
                  back(model)
                  menstrualDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getTable")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_function_table(serializedData: response.data,partial: true)
               if let back = tableDic[call.method]{
                  back(model)
                  tableDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
         
      }
      else if(call.method.contains("getSOSContacts")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_emergency_contacts_inquire_reply(serializedData: response.data,partial: true)
               if let back = sosContactsDic[call.method]{
                  back(model)
                  sosContactsDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getFocus")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_focus_mode_inquire_reply(serializedData: response.data,partial: true)
               if let back = focusDic[call.method]{
                  back(model)
                  focusDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getAppList")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_app_list_inquire_reply(serializedData: response.data,partial: true)
               if let back = appListDic[call.method]{
                  back(model)
                  appListDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getEventTracking")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_event_tracking_inquire_reply(serializedData: response.data,partial: true)
               if let back = eventTrackingDic[call.method]{
                  back(model)
                  eventTrackingDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      
      else if(call.method == "noticeUpdate"){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(NoticeUpdateModel.self, dic){
                  if let back = _noticeUpdateListen{
                     back(model)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method == "eventReport"){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(EventReportModel.self, dic){
                  if let back = _eventReportListen{
                     back(model)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method == "exceptionListen"){
         if let response = call.arguments as? String{
            if let back = _exceptionListen{
               back(response)
            }
         }
         
      }
      else if(call.method.contains("getSportUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[SportModel]>.self, dic){
                  if let back = sportsClosureDic[call.method]{
                     back(model);
                     sportsClosureDic.removeValue(forKey: call.method)
                     
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getActivityUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[ActivityModel]>.self, dic){
                  if let back = activitysClosureDic[call.method]{
                     back(model);
                     activitysClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getHeartRateUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[HeartRateModel]>.self, dic){
                  if let back = heartRatesClosureDic[call.method]{
                     back(model);
                     heartRatesClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getHrvUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[HrvModel]>.self, dic){
                  if let back = hrvsClosureDic[call.method]{
                     back(model);
                     hrvsClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getNoiseUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[NoiseModel]>.self, dic){
                  if let back = noisesClosureDic[call.method]{
                     back(model);
                     noisesClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getStressUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[StressModel]>.self, dic){
                  if let back = stresssClosureDic[call.method]{
                     back(model);
                     stresssClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSleepUploadDays")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[SleepModel]>.self, dic){
                  if let back = sleepsClosureDic[call.method]{
                     back(model);
                     sleepsClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("getSpoUploadStatus")){
         if let response = call.arguments as? String{
            do{
               let dic = try JSONSerialization.jsonObject(with: (response.data(using: .utf8))!)
               if let model = ParseJson.jsonToModel(BaseModel<[OxygenModel]>.self, dic){
                  if let back = oxygensClosureDic[call.method]{
                     back(model);
                     oxygensClosureDic.removeValue(forKey: call.method)
                  }
               }
               
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }
      else if(call.method.contains("rawQueryDB")){
         if let response = call.arguments as? String{
            if let back = rawQueryDBClosureDic[call.method]{
               back(response)
               rawQueryDBClosureDic.removeValue(forKey: call.method)
            }
         }
         
      }else if(call.method.contains("encodeOnlineFile") || call.method.contains("encodeOfflineFile") || call.method.contains("encodePhoneFile")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = ephemerisClosureDic[call.method]{
               back(response.data);
               ephemerisClosureDic.removeValue(forKey: call.method)
               
            }
         }
      } else if(call.method == "logPath"){
         if let response = call.arguments as? String{
            if let back = logPathClosure{
               back(response)
            }
         }
      }else if(call.method.contains("getSNFirmware")){
         if let response = call.arguments as? String{
            if let back = SNFirmwareDic[call.method]{
               back(response);
               SNFirmwareDic.removeValue(forKey: call.method)
            }
         }
      }else if(call.method.contains("parseDial")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialParseModel.self, response){
               if let back = parseDialClosureDic[call.method]{
                  back(model);
                  parseDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
      }else if(call.method.contains("parsePhotoDial")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialPhotoParseModel.self, response){
               if let back = parsePhotoDialClosureDic[call.method]{
                  back(model);
                  parsePhotoDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
      }else if(call.method.contains("parseVideoDial")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialVideoParseModel.self, response){
               if let back = parseVideoDialClosureDic[call.method]{
                  back(model);
                  parseVideoDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
      }else if(call.method.contains("setCurrentColor")){
         
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialParseModel.self, response){
               if let back = parseDialClosureDic[call.method]{
                  back(model);
                  parseDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
         
      }else if(call.method.contains("setCurrentPhotoColor")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialPhotoParseModel.self, response){
               if let back = parsePhotoDialClosureDic[call.method]{
                  back(model);
                  parsePhotoDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
         
      }else if(call.method.contains("setCurrentVideoColor")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialVideoParseModel.self, response){
               if let back = parseVideoDialClosureDic[call.method]{
                  back(model);
                  parseVideoDialClosureDic.removeValue(forKey: call.method)
               }
            }
         }
         
      }else if(call.method.contains("setCurrentBackgroundImagePath")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialParseModel.self, response){
               if let back = parseDialClosureDic[call.method]{
                  back(model);
                  parseDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
            
         }
      }else if(call.method.contains("setCurrentClockPosition")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialPhotoParseModel.self, response){
               if let back = parsePhotoDialClosureDic[call.method]{
                  back(model);
                  parsePhotoDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
         
      }else if(call.method.contains("setCurrentVideoClockPosition")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialVideoParseModel.self, response){
               if let back = parseVideoDialClosureDic[call.method]{
                  back(model);
                  parseVideoDialClosureDic.removeValue(forKey: call.method)
               }
            }
         
         }
         
      }else if(call.method.contains("setCurrentPhotoBackgroundImagePath")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialPhotoParseModel.self, response){
               if let back = parsePhotoDialClosureDic[call.method]{
                  back(model);
                  parsePhotoDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
         }
         
      }else if(call.method.contains("setCurrentFunction")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(DialParseModel.self, response){
               if let back = parseDialClosureDic[call.method]{
                  back(model);
                  parseDialClosureDic.removeValue(forKey: call.method)
               }
            }
            
            
         }
      }else if(call.method.contains("getPreviewImage")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = previewImageClosureDic[call.method]{
               back(response.data)
               previewImageClosureDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("encodeDial")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = dialDataClosureDic[call.method]{
               back(response.data)
               dialDataClosureDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("encodePhotoDial")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = dialDataClosureDic[call.method]{
               back(response.data)
               dialDataClosureDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("ephemerisInit")){
         
         if let back = _gpsClosure{
            let model = back()
            ephemerisInitGPS(model: model)
         }
         
      }
      else if(call.method.contains("ephemerisGPS")){
         
         
      }
      else if(call.method.contains("checkPhoneBookPermissions")){
         if let response = call.arguments as? Bool{
            if let back = boolClosureDic[call.method]{
               back(response)
               boolClosureDic.removeValue(forKey: call.method)
            }
         }
         
      }
      else if(call.method.contains("requestPhoneBookPermissions")){
         if let response = call.arguments as? Bool{
            if let back = boolClosureDic[call.method]{
               back(response)
               boolClosureDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("getOTAUpgradeVersion")){
         if let response = call.arguments as? Int{
            if let back = valueClosureDic[call.method]{
               back(response)
               valueClosureDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("getOTAUpgradeState")){
         if let response = call.arguments as? [String:Any]{
            if let model = ParseJson.jsonToModel(UpgradeModel.self, response){
               if let back = upgradeStateClosureDic[call.method]{
                  back(model);
                  upgradeStateClosureDic.removeValue(forKey: call.method)
               }
            }
         }
      }
      else if(call.method.contains("bluetoothStateListen")){
         if let response = call.arguments as? Int{
            if let back = _bluetoothStateListen{
               var blueState = BluetoothState.unknown
               switch response {
               case 0:
                  blueState = .unknown
                  break
               case 2:
                  blueState = .unauthorized
                  break
               case 4:
                  blueState = .on
                  break
               case 6:
                  blueState = .off
                  break
               default:
                  break
               }
               back(blueState)
            }
         }
      }else if(call.method.contains("encodeContacts")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = contactsIconClosureDic[call.method]{
               back(response.data);
               contactsIconClosureDic.removeValue(forKey: call.method)
               
            }
         }
      }else if(call.method.contains("watchResetListen")){
         if let back = _watchResetListen{
            back();
         }
      }
      else if(call.method.contains("getCalendar")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_calendar_inquire_reply(serializedData: response.data,partial: true)
               if let back = calendarDic[call.method]{
                  back(model)
                  calendarDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getDirectionWatch")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_watch_direction_inquire_reply(serializedData: response.data,partial: true)
               if let back = watchDirectionDic[call.method]{
                  back(model)
                  watchDirectionDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getMorning")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_good_morning_inquire_reply(serializedData: response.data,partial: true)
               if let back = morningDic[call.method]{
                  back(model)
                  morningDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getHealthSnapshotList")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_health_snap_inquire_reply(serializedData: response.data,partial: true)
               if let back = healthSnapshotDic[call.method]{
                  back(model)
                  healthSnapshotDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getMusicList")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_music_file_inquire_reply(serializedData: response.data,partial: true)
               if let back = musicDic[call.method]{
                  back(model)
                  musicDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getCourse")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_course_list_inquire_reply(serializedData: response.data,partial: true)
               if let back = courseDic[call.method]{
                  back(model)
                  courseDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }
      else if(call.method.contains("getGeo")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_geobin_inquire_reply(serializedData: response.data,partial: true)
               if let back = geoDic[call.method]{
                  back(model)
                  geoDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }else if(call.method.contains("geoUpload")){
         if let response = call.arguments as? NSArray{
            if let back = _geoAddressClosure{
               let model = back(response[0] as! Double,response[1] as! Double)
               routeAddress(model: model)
            }
         }
         
      } else if(call.method.contains("getAuthorizationCode")){
         if let response = call.arguments as? String{
            if let back = authorizationCodeDic[call.method]{
               back(response)
               authorizationCodeDic.removeValue(forKey: call.method)
            }
         }
         
      }else if(call.method.contains("channelCompleted")){
         if let back = channelCompletedClosure{
            back()
         }
         
      } else if(call.method.contains("getGPXEncodeUint8List")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = GPXDic[call.method]{
               back(response.data)
               GPXDic.removeValue(forKey: call.method)
            }
         }
         
      } else if(call.method.contains("getSensorWatch")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_watch_sensors_inquire_reply(serializedData: response.data,partial: true)
               if let back = watchSensorDic[call.method]{
                  back(model)
                  watchSensorDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      } else if(call.method.contains("getAssistantWater")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_water_assistant_inquire_reply(serializedData: response.data,partial: true)
               if let back = waterAssistantDic[call.method]{
                  back(model)
                  waterAssistantDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
         
      }else if(call.method == "liveSportDataListen"){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_sync_realtime_info(serializedData: response.data,partial: true)
               if let back = _liveSportDataListen{
                  back(model)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }else if(call.method == "liveSportControlListen"){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try protocol_exercise_control_operate(serializedData: response.data,partial: true)
               if let back = _liveSportControlListen{
                  back(model)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
            
         }
         
      }else if(call.method.contains("queryFirmwareUpdate")){
         if let response = call.arguments as? FlutterStandardTypedData{
            do{
               let model = try firmware_update_response(serializedData: response.data,partial: true)
               if let back = firmwareUpdateDic[call.method]{
                  back(model)
                  firmwareUpdateDic.removeValue(forKey: call.method)
               }
            }catch{
               print("Error converting string to dictionary: \(error.localizedDescription)")
            }
         }
      }
      else if(call.method.contains("setVideoDial")){
         if let response = call.arguments as? String{
            if let back = backStringBaseDic[call.method]{
               back(response)
               backStringBaseDic.removeValue(forKey: call.method)
            }
         }
         
      }else if(call.method.contains("encodeVideoDial")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = dialDataClosureDic[call.method]{
               back(response.data)
               dialDataClosureDic.removeValue(forKey: call.method)
            }
         }
      }else if(call.method.contains("calendarConfig")){
         if let response = call.arguments as? String{
            if let back = backStringBaseDic[call.method]{
               back(response)
            }
         }
      }else if(call.method.contains("checkCalendarPermission")){
         if let response = call.arguments as? Int{
            if let back = boolClosureDic[call.method]{
               back((response == 1 ? true : false))
               boolClosureDic.removeValue(forKey: call.method)
            }
         }
      }else if(call.method.contains("requestCalendarPermission")){
         if let response = call.arguments as? Int{
            if let back = boolClosureDic[call.method]{
               back((response == 1 ? true : false))
               boolClosureDic.removeValue(forKey: call.method)
            }
         }
      }else if(call.method.contains("aiChat") || call.method.contains("aiAnalysisActivity") || call.method.contains("aiAnalysisSleep") || call.method.contains("aiAnalysisSport") ||  call.method.contains("aicourse")){
         if let response = call.arguments as? String{
            if let back = backStringBaseDic[call.method]{
               back(response)
               backStringBaseDic.removeValue(forKey: call.method)
            }
         }
      }
      else if(call.method.contains("aiDialPcm")){
         if let response = call.arguments as? FlutterStandardTypedData{
            if let back = dialDataClosureDic[call.method]{
               back(response.data)
            }
         }
         
      }
      else if(call.method.contains("aiDialText")){
         if let response = call.arguments as? String{
            if let back = backStringBaseDic[call.method]{
               back(response)
            }
         }
      }
      
   }
   
}

extension CreekSDK{
   
   //MARK:ConnectionStatus
   func getConnectionStatus(_ state:Int) -> connectionStatus {
      var status:connectionStatus = .none
      switch state{
      case 0:
         status = .none
         break;
      case 1:
         status = .connect
         break;
      case 2:
         status = .connecting
         break;
      case 3:
         status = .sync
         break;
      case 4:
         status = .syncComplete
         break;
      case 5:
         status = .unconnected
         break;
      case 6:
         status = .inTransition
         break;
      default:
         break
      }
      return status;
   }
}





