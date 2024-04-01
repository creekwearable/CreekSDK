//
//  ProtoExtension.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/4/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit


class ScreenTable: NSObject {
    ///Whether automatic brightness adjustment at night is supported bit0
    var night = false
    
    ///Whether it supports always-on mode selection, supports using aod_time_setting, does not support using aod_switch_flag bit1
    var steady = false
    
    ///Whether the bright screen duration display option is supported
    var option = false
}


extension protocol_screen_brightness_inquire_reply{
    
    func fromTable() -> ScreenTable {
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


extension Int{
    func decimalToBinary() -> String {
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

