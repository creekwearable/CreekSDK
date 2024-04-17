//
//  extension_color.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/1/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//


import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    /** 16 */
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        
        var rgb : UInt32 = 0
        
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") { //
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt32(&rgb)
        
        let r = CGFloat((rgb & 0xff0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xff00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xff) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}


extension Array where Element == Int {
    func toData() -> Data {
        var copy = self
        return Data(bytes: &copy, count: self.count * MemoryLayout<Int>.size)
    }
}

func convertDataToMACAddress(_ data: Data) -> String {
    var macAddress = ""
    for byte in data.reversed() {
        if !macAddress.isEmpty {
            macAddress += ":"
        }
        macAddress += String(format: "%02X", byte)
    }
    return macAddress
}
