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
      case "Get device information":
         self.view.hideRemark()
//         CreekInterFace.instance.aiChat(content: "Help me create a 30-minute running session.",userId: "1234567") { str in
//            print(str)
//         } courseJson: { str in
//            print(str)
//         } failure: { code, message in
//            print(message)
//         }
//         
//         CreekInterFace.instance.aiAnalysisSleep(sleepModel: SleepModel(),langCode: "en",userId: "1234567") { str in
//            print(str)
//         } failure: { code, message in
//            print(message)
//         }
//         
//         CreekInterFace.instance.aiAnalysisSport(sportModel: SportModel(), langCode: "en", userId: "1234567", age: 28, gender: .genderFemale) { str in
//            print("aiAnalysisSport:\(str)")
//         } failure: { code, message in
//            print("aiAnalysisSport:\(message)")
//         }
//         
//         CreekInterFace.instance.aiAnalysisActivity(activityModel: ActivityModel(), goalsModel: GoalsModel(), langCode: "en", userId: "123456", height: 178, weight: 65.5) { str in
//            print("aiAnalysisActivity:\(str)")
//         } failure: { code, message in
//            print("aiAnalysisActivity:\(message)")
//         }



         
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
      case "Get user information":
         
         CreekInterFace.instance.getUserInfo{ model in
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
      case "Set user information":
         CreekInterFace.instance.getUserInfo { model in
            var data = model
            data.personalInfo.year = 2024
            data.personalInfo.month = 11
            data.goalSetting.workoutDay = 7
            data.goalSetting.steps = 100
            data.perferences.distUnit = 1
            data.goalSetting.notifyFlag = .close
            data.perferences.walkingRunningUnit = 2
            data.personalInfo.gender = .genderMale
            CreekInterFace.instance.setUserInfo(model: data) {
               self.view.hideRemark()
               self.textView.text = "success"
            } failure: { code, message in
               self.view.hideRemark()
               self.textView.text = message
            }
            
         } failure: { code, message in
            self.view.hideRemark()
         }
         
         break
         
      case "Query time":
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
      case "Set time":
         CreekInterFace.instance.syncTime {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Upload (OTA)":
         
         break
      case "Bind device":
         CreekInterFace.instance.bindingDevice(bindType: .binNormal, id: nil, code: nil, success: {
            self.textView.text = "success"
         }, failure: {
            self.textView.text = "failure"
         })
         break
      case "Unbind":
         CreekInterFace.instance.bindingDevice(bindType: .bindRemove, id: nil, code: nil, success: {
            self.textView.text = "success"
         }, failure: {
            self.textView.text = "failure"
         })
         break
      case "Sync health":
         CreekInterFace.instance.sync { progress in
            self.textView.text = "progress\(progress)"
         } syncSuccess: {
            self.textView.text = "success"
         } syncFailure: {
            self.textView.text = "failure"
         }
         break
      case "Get watch dial":
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
      case "Set watch dial":
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
      case "Delete watch dial":
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
      case "Get table":
         CreekInterFace.instance.getTable { model in
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
      case "Get language":
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
      case "Set language":
         CreekInterFace.instance.setLanguage(type: .japanese) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Get alarms":
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
      case "Set alarms":
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
      case "Get disturb":
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
         
      case "Set disturb":
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
      case "Get contacts":
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
      case "Set contacts":
         CreekInterFace.instance.getContacts { model in
            if model.fromTable().contact_icon{
               let fileManager = FileManager()
               if var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                  documentsURL.appendPathComponent("directory/F4:4E:FD:C3:77:37/circlePhoto/firmware/218502.png")
                   let path = documentsURL.path
             
                  var contactsIconModels:[ContactsIconModel] = []
                  for i in 0...9 {
                     let contactsIconModel = ContactsIconModel()
                     contactsIconModel.phoneNum = "1234567891\(i)"
                     contactsIconModel.path = path
                     contactsIconModel.w =  Int(model.contactIconWidth)
                     contactsIconModel.h = Int(model.contactIconHeight)
                     contactsIconModel.isLz4 = model.fromTable().contact_icon_lz4 ? 1 : 0
                     ///For unsupported hardware versions of lz4, set the image quality to 100, and for supported versions, set the range from 10 to 100.
                     contactsIconModel.quality = model.fromTable().contact_icon_lz4 ? 10 : 100
                     contactsIconModels.append(contactsIconModel)
                  }
                  
                   CreekInterFace.instance.encodeContacts(contactsIconModels) { model in
                      CreekInterFace.instance.upload(fileName: "icon.contact_icon", fileData: model) { progress in
                         dispatch_main_sync_safe {
                            self.textView.text = "\(progress)"
                         }
                      } uploadSuccess: {
                         
                         var data =  protocol_frequent_contacts_operate()
                         for i in 0...9 {
                            var item =  protocol_frequent_contacts_item()
                            item.phoneNumber = "1234567891\(i)".data(using: .utf8)!
                            item.contactName = "bean\(i)".data(using: .utf8)!
                            data.contactsItem.append(item)
              
                         }
                      
                         CreekInterFace.instance.setContacts(model: data) {
                            self.view.hideRemark()
                            self.textView.text = "success"
                         } failure: { code, message in
                            self.view.hideRemark()
                            self.textView.text = message
                         }
                         
         
                         
                      } uploadFailure: { code, message in
                         self.view.hideRemark()
                         dispatch_main_sync_safe {
                            self.textView.text = "\(message)"
                         }
                      }

                   } failure: { code, message in
                      self.view.hideRemark()
                      dispatch_main_sync_safe {
                         self.textView.text = "\(message)"
                      }
                   }
               }
               
            }else{
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
            }
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         break
      case "Get SOS contacts":
         CreekInterFace.instance.getContactsSOS{ model in
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
      case "Set SOS contacts":
         var  operate =  protocol_emergency_contacts_operate();
         var item = protocol_emergency_contacts_item();
         item.phoneNumber =  "12345678912".data(using: .utf8)!
         item.contactName =  "bean".data(using: .utf8)!
         operate.contactsItem.append(item);
         CreekInterFace.instance.setContactsSOS(model: operate, success: {
            self.textView.text = "success"
         }, failure: { code, message in
            self.textView.text = message
         })
         break
      case "Get shortcut keys":
         CreekInterFace.instance.getHotKey{ model in
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
      case "Set shortcut keys":
         var operate = protocol_button_crown_operate();
         operate.pauseWorkout = true;
         operate.longType = .pressTypeSos;
         CreekInterFace.instance.setHotKey(model: operate, success: {
            self.textView.text = "success"
         }, failure: { code, message in
            self.textView.text = message
         })
         break
      case "Get card":
         CreekInterFace.instance.getCard{ model in
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
      case "Get message on/off":
         CreekInterFace.instance.getMessageOnOff{ model in
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
      case "Set message on/off":
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
         
      case "Get call":
         CreekInterFace.instance.getCall{ model in
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
      case "Set call":
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
         
      case "Get health monitor":
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
      case "Set health monitor":
         
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
      case "Get world clock":
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
      case "Set world clock":
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
      case "Get stand":
         CreekInterFace.instance.getStanding{ model in
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
      case "Set stand":
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
      case "Get water":
         CreekInterFace.instance.getWater{ model in
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
      case "Set water":
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
      case "Get focus":
         CreekInterFace.instance.getFocusSleep{ model in
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
      case "Set focus":
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
      case "Get app list":
         CreekInterFace.instance.getAppList{ model in
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
      case "Set app list":
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
      case "Get screen":
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
      case "Set screen":
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
         
      case "Get activity data":
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currentDateStr = formatter.string(from: Date())
         CreekInterFace.instance.getActivityNewTimeData(startTime: currentDateStr, endTime: currentDateStr) { model in
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
         
      case "Get sleep data":
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currentDateStr = formatter.string(from: Date())
         CreekInterFace.instance.getSleepNewTimeData(startTime: currentDateStr, endTime: currentDateStr) { model in
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
      case "Get heart rate data":
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currentDateStr = formatter.string(from: Date())
         CreekInterFace.instance.getHeartRateNewTimeData(startTime: currentDateStr, endTime: currentDateStr) { model in
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
      case "Get stress data":
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currentDateStr = formatter.string(from: Date())
         CreekInterFace.instance.getStressNewTimeData(startTime: currentDateStr, endTime: currentDateStr) { model in
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

      case "Get blood oxygen data":
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         let currentDateStr = formatter.string(from: Date())
         CreekInterFace.instance.getSpoNewTimeData(startTime: currentDateStr, endTime: currentDateStr) { model in
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
         
      case "Get sport data":
         CreekInterFace.instance.getSportTimeData(startTime: "2023-11-20", endTime: "2025-11-20",nil) { model in
            self.view.hideRemark()
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
      case "Set database user ID":
         CreekInterFace.instance.setDBUser(nil)
         self.view.hideRemark()
         
         break
         
      case "Get Watch Sensor":
         CreekInterFace.instance.getWatchSensor{ model in
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
      case "Set Watch Sensor":
          ///这个为true的时候，代表健康监测改成了传感器设置
         /// protocol_function_table().waterAssistant.isSupport
         
         var  operate =  protocol_watch_sensors_operate()
         operate.heartRateAllSwitch = .switchOff
         operate.bloodOxygenAllSwitch = .switchOn
//         operate.compassAllSwitch = .switchOn
//         operate.baromaterAllSwitch = .switchOn
         CreekInterFace.instance.setWatchSensor(model: operate) {
            self.view.hideRemark()
            self.textView.text = "success"
         } failure: { code, message in
            self.view.hideRemark()
            self.textView.text = message
         }
         
         break
         
      case "Get Water Assistant":
         CreekInterFace.instance.getWaterAssistant{ model in
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
