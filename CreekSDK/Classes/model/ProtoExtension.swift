//
//  ProtoExtension.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/4/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit


public class ScreenTable: NSObject {
    ///Whether automatic brightness adjustment at night is supported bit0
   public var night = false
    
    ///Whether it supports always-on mode selection, supports using aod_time_setting, does not support using aod_switch_flag bit1
   public var steady = false
    
    ///Whether the bright screen duration display option is supported
   public var option = false
}


extension protocol_screen_brightness_inquire_reply{
    
   public func fromTable() -> ScreenTable {
        let screenTable = ScreenTable()
        let str = Int(funcTable).decimalToBinary()
        if let firstChar = str[safe: 0] {
            if let intValue = Int(String(firstChar)) {
                screenTable.night = (intValue == 1)
            }
        }
        if let secondChar = str[safe: 1] {
            if let intValue = Int(String(secondChar)) {
                screenTable.steady = (intValue == 1)
            }
        }
        if let thirdChar = str[safe: 2] {
            if let intValue = Int(String(thirdChar)) {
                screenTable.option = (intValue == 1)
            }
        }
        return screenTable
    }
    
}

public class AlarmTable: NSObject {
    ///Whether to support custom modification of later reminder minutes, field: later_remind_min
   public var later_remind_min = false
    
    ///Whether to support alarm clock custom label used options, field: custom_name_list
   public var custom_name_list = false
    
}

extension protocol_alarm_inquire_reply{
   
   public func fromTable() -> AlarmTable {
       let alarmTable = AlarmTable()
       let str = Int(funcTable).decimalToBinary()
       if let firstChar = str[safe: 0] {
           if let intValue = Int(String(firstChar)) {
              alarmTable.later_remind_min = (intValue == 1)
           }
       }
       if let secondChar = str[safe: 1] {
           if let intValue = Int(String(secondChar)) {
              alarmTable.custom_name_list = (intValue == 1)
           }
       }
       return alarmTable
   }
   
}

public class UserInfoTable: NSObject {
    ///Whether to support wind speed unit
   public var wind_speed_unit = false
    
    ///Whether to support visibility units
   public var visibility_unit = false
    
}

extension protocol_user_info_inquire_reply{
   
   public func fromTable() -> UserInfoTable {
       let userInfoTable = UserInfoTable()
       let str = Int(funcTable).decimalToBinary()
       if let firstChar = str[safe: 0] {
           if let intValue = Int(String(firstChar)) {
              userInfoTable.wind_speed_unit = (intValue == 1)
           }
       }
       if let secondChar = str[safe: 1] {
           if let intValue = Int(String(secondChar)) {
              userInfoTable.visibility_unit = (intValue == 1)
           }
       }
       return userInfoTable
   }
   
}

public class ContactsTable: NSObject {
   ///Whether to support wind speed unit
   public var contact_icon = false
   ///Does the contact avatar support compression?
   public var contact_icon_lz4 = false
    
}

extension protocol_frequent_contacts_inquire_reply{
   
   public func fromTable() -> ContactsTable {
       let contactsTable = ContactsTable()
       let str = Int(funcTable).decimalToBinary()
       if let firstChar = str[safe: 0] {
           if let intValue = Int(String(firstChar)) {
              contactsTable.contact_icon = (intValue == 1)
           }
       }
      if let secondChar = str[safe: 1] {
          if let intValue = Int(String(secondChar)) {
             contactsTable.contact_icon_lz4 = (intValue == 1)
          }
      }
      
       return contactsTable
   }
   
}


extension Int{
   public func decimalToBinary() -> String {
        var decimalNumber = self
        var binaryString = ""
        while decimalNumber > 0 {
            let remainder = decimalNumber % 2
            binaryString = String(remainder) + binaryString
            decimalNumber /= 2
        }
        return binaryString
    }
}
extension String {
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
}

