//
//  CommandReplyViewController.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/7/12.
//

import UIKit
import CreekSDK

class CommandReplyViewController: CreekBaseViewController {
   
   lazy var seedBtn:UIButton = {
      let btn = UIButton.init()
      btn.backgroundColor = .red
      btn.setTitle("Command", for: .normal)
      btn.setTitleColor(.white, for: .normal)
      btn.isUserInteractionEnabled = true
      btn.layer.cornerRadius = FBScale(20)
      btn.layer.masksToBounds = true
      btn.addTarget(self, action: #selector(commandClick), for: .touchUpInside)
      btn.isSelected = false
      return btn
   }()
   lazy var textView:UITextView = {
      let text = UITextView.init(frame: CGRect.zero)
      text.text = ""
      text.textColor = .white
      text.backgroundColor = .gray
      text.isUserInteractionEnabled = false
      return text
   }()
   
   var titleStr = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
      layOutUI()
   }
   
   func layOutUI(){
      view.addSubview(seedBtn)
      view.addSubview(textView)
      seedBtn.snp.makeConstraints {
         $0.top.equalTo(SAFEAREAINSETS.top + 44)
         $0.centerX.equalTo(view.snp.centerX)
         $0.width.equalTo(FBScale(300))
         $0.height.equalTo(FBScale(100))
      }
      textView.snp.makeConstraints {
         $0.top.equalTo(seedBtn.snp.bottom).offset(FBScale(20))
         $0.left.equalTo(FBScale(20))
         $0.right.equalTo(-FBScale(20))
         $0.height.greaterThanOrEqualTo(0)
         $0.bottom.equalTo(view.snp.bottom).offset(-FBScale(100))
      }
   }
   
   @objc func commandClick(){
      self.view.showRemark(msg: "loding....")
      switch titleStr{
      case "Get Device Information":
         CreekInterFace.instance.getFirmware { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
            CreekInterFace.instance.getSNFirmware(model: model) { sn in
               print("sn++++\(sn)")
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         
         break
      case "Get Device Bluetooth Status":
         
         CreekInterFace.instance.bluetoothStatus { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         
         break
      case "connect Bluetooth Status":
         
         CreekInterFace.instance.firmwareReconnect(reconnect: true, success: {
            
         }, failure: { code, message in
            
         })
         
         break
         
      case "Sync Time":
         CreekInterFace.instance.syncTime {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Get Time":
         
         CreekInterFace.instance.getTime { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Get User Information":
         CreekInterFace.instance.getUserInfo { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
            
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Set User Information":
         CreekInterFace.instance.getUserInfo { model in
            var data = model
            data.personalInfo.year = 2024
            data.personalInfo.month = 11
            data.goalSetting.workoutDay = 7
            data.goalSetting.steps = 100
            data.preferences.distUnit = 1
            data.goalSetting.notifyFlag = .close
            data.preferences.walkingRunningUnit = 2
            CreekInterFace.instance.setUserInfo(model: data) {
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
            
         } failure: { code, message in
            
         }
         break
      case "Get Alarm Clock":
         CreekInterFace.instance.getAlarm{ model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
            
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Set Alarm Clock":
         CreekInterFace.instance.getAlarm { model in
            var data = protocol_alarm_operate()
            data.alarmItem = model.alarmItem
            var item = protocol_set_alarm_item()
            item.alarmID = 1;
            item.dispStatus = .dispOn
            item.type = .getUp
            item.hour = 22
            item.minute = 30
            item.repeat = [true,true,true,true,true,false,false]
            item.switchFlag = false
            item.laterRemindRepeatTimes = 1
            item.vibrateOnOff = true
            item.name = "abc".data(using: .utf8)!
            item.laterRemindMin = 10
            data.alarmItem.append(item)
            if model.fromTable().custom_name_list{
               data.customNameList.append("hello".data(using: .utf8)!)
               data.customNameList.append("hello2".data(using: .utf8)!)
            }
            if model.fromTable().later_remind_min{
               item.laterRemindMin = 1
            }
            CreekInterFace.instance.setAlarm(model:data){
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
            
         } failure: { code, message in
            
         }
         break
      case "Get Do Not Disturb":
         CreekInterFace.instance.getDisturb{ model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Set Do Not Disturb":
         var model = protocol_disturb_operate()
         model.disturbOnOff = true
         model.num = 1
         var b = protocol_set_disturb_item()
         b.disturbID = 0
         b.switchFlag = true
         b.startHour = 15
         b.endHour = 16
         b.endMinute = 59
         model.disturbItem = [b]
         
         CreekInterFace.instance.setDisturb(model: model) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Get Screen Brightness":
         CreekInterFace.instance.getScreen{ model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Set Screen Brightness":
         CreekInterFace.instance.getScreen{ model in
            var operate =  protocol_screen_brightness_operate()
            let screenTable = model.fromTable()
            if  screenTable.steady{
               var aod = protocol_screen_aod_time_setting()
               aod.mode = .intelligentMode
               aod.startHour = 8
               aod.startMinute = 0
               aod.endHour = 10
               aod.endMinute = 0
               operate.aodTimeSetting = aod
            }else{
               operate.aodSwitchFlag = true
            }
            operate.level = 100
            operate.showInterval = 5
            operate.levelFlag = true
            
            CreekInterFace.instance.setScreen(model: operate) {
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         
         break
         
      case "Get Health Monitoring":
         var data =  protocol_health_monitor_operate()
         data.healthType = health_type.heartRate
         CreekInterFace.instance.getMonitor(operate: data) { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Health monitoring setting":
         
         var data =  protocol_health_monitor_operate()
         data.healthType = health_type.spo2
         data.defaultMode = .manual
         data.measurementInterval = 600
         CreekInterFace.instance.setMonitor(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Sleep monitoring setting":
         var data =  protocol_sleep_monitor_operate()
         data.switchFlag = true
         CreekInterFace.instance.setSleepMonitor(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Sleep monitoring acquisition":
         CreekInterFace.instance.getSleepMonitor { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
         
      case "World clock setting":
         var data =  protocol_world_time_operate()
         var item = protocol_world_time_item()
         item.cityName =  "shenzheng".data(using: .utf8)!
         item.offestMin = 120
         item.customMin = -180
         data.worldTimeItem.append(item)
         CreekInterFace.instance.setWorldTime(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "World clock acquisition":
         CreekInterFace.instance.getWorldTime { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
         
         
      case "Message switch query":
         CreekInterFace.instance.getMessageOnOff { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Message switch setting":
         var data =  protocol_message_notify_switch()
         data.notifySwitch = true
         var item = protocol_message_notify_switch_item()
         item.remindType = .qq
         item.notifyFlag = .allow
         data.items.append(item)
         CreekInterFace.instance.setMessageOnOff(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Set weather":
         var data =  protocol_weather_operate()
         data.switchFlag = true
         var item = protocol_weather_detail_data_item()
         let currentDate = Date()
         let calendar = Calendar.current
         let month = calendar.component(.month, from: currentDate)
         let day = calendar.component(.day, from: currentDate)
         let hour = calendar.component(.hour, from: currentDate)
         let minute = calendar.component(.minute, from: currentDate)
         item.month = UInt32(month)
         item.day = UInt32(day)
         item.hour = UInt32(hour)
         item.min = UInt32(minute)
         item.curTemp = 30
         item.curMaxTemp = 33
         item.curMinTemp = 26
         var item2 =  protocol_weather_sunrise_item()
         item2.sunriseHour = 8
         item2.sunsetHour = 18
         item.sunriseItems.append(item2)
         item.visibilityLevel = "hello".data(using: .utf8)!
         data.detailDataItem.append(item)
        
         CreekInterFace.instance.setWeather(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Incoming call configuration query":
         CreekInterFace.instance.getCall { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Incoming call configuration settings":
         var data =  protocol_call_switch()
         data.callSwitch = true
         data.callDelay = 5
         CreekInterFace.instance.setCall(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Contacts query":
         CreekInterFace.instance.getContacts { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Contacts settings":
         var data =  protocol_frequent_contacts_operate()
         var item =  protocol_frequent_contacts_item()
         item.phoneNumber = "12345678912".data(using: .utf8)!
         item.contactName = "bean".data(using: .utf8)!
         data.contactsItem.append(item)
         CreekInterFace.instance.setContacts(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
         
      case "Exercise self-identification query":
         CreekInterFace.instance.getSportIdentification { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Exercise self-identification settings":
         var data =  protocol_exercise_intelligent_recognition()
         data.walkTypeSwitch = true
         CreekInterFace.instance.setSportIdentification(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Exercise sub-item data query":
         CreekInterFace.instance.getSportSub { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Exercise sub-item data setting":
         var data =  protocol_exercise_sporting_param_sort()
         data.sportType = UInt32(sport_type.barbell.rawValue)
         CreekInterFace.instance.setSportSub(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Inquiry about the arrangement order of device exercise":
         CreekInterFace.instance.getSportSort { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Setting the arrangement order of device exercise":
         var data =  protocol_exercise_sport_mode_sort()
         data.sportItems.append(sport_type.badminton)
         CreekInterFace.instance.setSportSort(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Get the type of exercise supported by the device":
         CreekInterFace.instance.getSportType { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
         
      case "Setting the heart rate interval":
         var data =  protocol_exercise_heart_rate_zone()
         data.zone1 = 133
         data.zone2 = 144
         data.zone3 = 155
         data.zone4 = 166
         data.zone5 = 177
         data.zone6 = 190
         CreekInterFace.instance.setSportHeartRate(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      case "Delete the dial":
         var data =  protocol_watch_dial_plate_operate()
         data.dialName = ["1".data(using: .utf8)!]
         CreekInterFace.instance.delWatchDial(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Set the dial":
         var data =  protocol_watch_dial_plate_operate()
         data.dialName = ["1".data(using: .utf8)!]
         CreekInterFace.instance.setWatchDial(model: data) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Query the dial":
         CreekInterFace.instance.getWatchDial { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Set Language":
         CreekInterFace.instance.setLanguage(type: .japanese) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Get Language":
         CreekInterFace.instance.getLanguage { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "System operation":
         CreekInterFace.instance.setSystem(type: 1) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Query activity data":
         CreekInterFace.instance.getActivityNewTimeData(startTime: "2024-05-24", endTime: "2024-07-24") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         
         break
         
      case "Query sleep data":
         CreekInterFace.instance.getSleepNewTimeData(startTime: "2023-08-01", endTime: "2023-08-03") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
      case "Query heart rate data":
         CreekInterFace.instance.getHeartRateNewTimeData(startTime: "2023-10-22", endTime: "2023-10-24") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
      case "Query pressure data":
         CreekInterFace.instance.getStressNewTimeData(startTime: "2023-08-01", endTime: "2023-08-03") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
      case "Query noise data":
         CreekInterFace.instance.getNoiseNewTimeData(startTime: "2023-08-01", endTime: "2023-08-03") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
      case "Query blood oxygen data":
         CreekInterFace.instance.getSpoNewTimeData(startTime: "2023-08-01", endTime: "2023-08-03") { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
      case "Exercise record list":
         CreekInterFace.instance.getSportRecord(nil) { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
         
      case "Query exercise details":
         CreekInterFace.instance.getSportDetails(id:1){ model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
         
      case "Range query exercise record":
         CreekInterFace.instance.getSportTimeData(startTime: "2023-08-01", endTime: "2023-08-03",nil) { model in
            if model.code == 0{
               self.view.hideRemark()
               self.textView.text = "success"
               let json = try? JSONEncoder().encode(model.data)
               if let data = json, let str = String(data: data, encoding: .utf8) {
                  dispatch_main_sync_safe {
                     self.textView.text = str
                  }
               }
            }
         }
         break
         
      case "Delete exercise record":
         CreekInterFace.instance.delSportRecord(id: 1) { model in
            self.view.hideRemark()
            self.textView.text = "success"
            let json = try? JSONEncoder().encode(model)
            if let data = json, let str = String(data: data, encoding: .utf8) {
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         }
         break
         
      case "Get bound device":
         CreekInterFace.instance.getBindDevice { model in
            self.view.hideRemark()
            let json = try? JSONEncoder().encode(model)
            if let data = json, let str = String(data: data, encoding: .utf8) {
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         }
         break
      case "setDBUserID":
         CreekInterFace.instance.setDBUser(nil)
         self.view.hideRemark()
         
         break
      case "rawQueryDB":
         CreekInterFace.instance.rawQueryDB("") { jsonString in
            self.view.hideRemark()
            self.textView.text = jsonString
         }
         
         break
      case "Off-line ephemeris":
         if let path =  Bundle.main.path(forResource: "offlineEphemeris", ofType: "agnss"){
            do {
               let fileData:Data = try Data(contentsOf: URL(fileURLWithPath: path))
               let ephemerisModel = EphemerisModel.init()
               ephemerisModel.startUtcTime = 1233
               ephemerisModel.socName = ""
               ephemerisModel.endUtcTime = 1233
               ephemerisModel.isVaild = true
               ephemerisModel.latitude = 22621883
               ephemerisModel.latitudeDire = "N"
               ephemerisModel.longitude = 114022530
               ephemerisModel.longitudeDire = "E"
               ephemerisModel.altitude = 10
               ephemerisModel.fileSize = fileData.count
               ephemerisModel.filePath = path
               CreekInterFace.instance.encodeOfflineFile(ephemerisModel, model: { model in
                  CreekInterFace.instance.backstageUpload(fileName: "offlineEphemeris.agnss", fileData: model) { progress in
                     print("offlineEphemeris progress\(progress)")
                  } uploadSuccess: {
                     self.view.hideRemark()
                     print("offlineEphemeris Success")
                  } uploadFailure: { code, message in
                     self.view.hideRemark()
                     print("offlineEphemeris Failure")
                  }
                  
                  
               }, failure: { code, message in
                  self.view.hideRemark()
               })
               
            } catch {
               print("\(error)")
            }
            
            
         }else{
            self.view.hideRemark()
            print("file does not exist")
         }
         break
      case "ephemeris":
         if let path =  Bundle.main.path(forResource: "realEphemeris", ofType: "gnss"){
            do {
               let fileData:Data = try Data(contentsOf: URL(fileURLWithPath: path))
               let ephemerisModel = EphemerisModel.init()
               ephemerisModel.startUtcTime = 1233
               ephemerisModel.socName = "1"
               ephemerisModel.endUtcTime = 1233
               ephemerisModel.isVaild = true
               ephemerisModel.latitude = 22621928
               ephemerisModel.latitudeDire = "N"
               ephemerisModel.longitude = 114023064
               ephemerisModel.longitudeDire = "E"
               ephemerisModel.altitude = 137
               ephemerisModel.fileSize = fileData.count
               ephemerisModel.filePath = path
               CreekInterFace.instance.encodeOnlineFile(ephemerisModel, model: { model in
                  CreekInterFace.instance.backstageUpload(fileName: "realEphemeris.gnss", fileData: model) { progress in
                     print("offlineEphemeris progress\(progress)")
                  } uploadSuccess: {
                     self.view.hideRemark()
                     print("offlineEphemeris Success")
                  } uploadFailure: { code, message in
                     self.view.hideRemark()
                     print("offlineEphemeris Failure")
                  }
                  
                  
               }, failure: { code, message in
                  self.view.hideRemark()
               })
               
            } catch {
               print("\(error)")
            }
            
            
         }else{
            self.view.hideRemark()
            print("file does not exist")
         }
         break
         
      case "phone book":
         let phone =  PhoneModel.init()
         phone.contactName = "bean"
         phone.phoneNumber = "13420902893"
         let phone2 =  PhoneModel.init()
         phone.contactName = "bean1"
         phone.phoneNumber = "13420902898"
         CreekInterFace.instance.encodePhoneFile([phone,phone2], model: { model in
            CreekInterFace.instance.backstageUpload(fileName: "creek.phone", fileData: model) { progress in
               print("encodePhoneFile progress\(progress)")
            } uploadSuccess: {
               self.view.hideRemark()
               print("encodePhoneFile Success")
            } uploadFailure: { code, message in
               self.view.hideRemark()
               print("encodePhoneFile Failure")
            }
            
         }, failure: { code, message in
            self.view.hideRemark()
         })
         
         break
      case "Get card":
         CreekInterFace.instance.getCard { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "Set card":
         CreekInterFace.instance.getCard { model in
            var operate =  protocol_quick_card_operate()
            var cardType:[quick_card_type] = []
            model.cardType.forEach { type in
               
               if type == .cardTypeDial {
                  if  model.cardTypeDialSupport.isDelete ==  false{
                     ///Removal is not supported and must be added
                     cardType.append(type)
                  }
                  
               }else{
                  ///All other changes can be removed
                  if type == .cardTypeActivity{
                     ///Remove
                  }else{
                     /// Add
                     cardType.append(type)
                  }
               }
               
            }
            operate.cardType =  cardType
            CreekInterFace.instance.setCard(model: operate) {
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
      case "getStand":
         CreekInterFace.instance.getStanding { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "setStand":
         var  operate =  protocol_standing_remind_operate()
         var standing =  protocol_standing_remind_set()
         ///Just set the switch  other attributes do not need to be set
         standing.switchFlag = true
         operate.standingRemind = standing
         CreekInterFace.instance.setStanding(model: operate) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
      case "getWater":
         
         CreekInterFace.instance.getWater { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "setWater":
         var  operate =  protocol_drink_water_operate()
         ///Only these 5 attributes need to be set, other attribute settings are invalid
         operate.switchFlag = true
         operate.startHour = 8
         operate.startMinute = 0
         operate.endHour = 18
         operate.endMinute = 0
         CreekInterFace.instance.setWater(model: operate) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
      case "getFocus":
         
         
         CreekInterFace.instance.getFocusSleep { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "setFocus":
         var  operate =  protocol_focus_mode_operate()
         var mode = protocol_focus_sleep_mode()
         mode.switchFlag = true
         mode.startHour = 22
         mode.endHour = 8
         mode.startMinute = 0
         mode.endMinute = 0
         operate.sleepMode = mode
         CreekInterFace.instance.setFocusSleep(model: operate) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "getAppList":
         CreekInterFace.instance.getAppList { model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "setAppList":
         CreekInterFace.instance.getAppList { model in
            var operate = protocol_app_list_operate()
            operate.list = model.list
            CreekInterFace.instance.setAppList(model: operate) {
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
      case "functionTable":
         CreekInterFace.instance.getTable{ model in
            self.view.hideRemark()
            let json = try? model.jsonString()
            if let str = json{
               dispatch_main_sync_safe {
                  self.textView.text = str
               }
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
         
      default:
         break
         
      }
   }
}
