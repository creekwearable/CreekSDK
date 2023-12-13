//
//  RootClass.swift
//
//
//  Created by JSONConverter on 2023/07/08.
//  Copyright © 2023年 JSONConverter. All rights reserved.
//

import Foundation


public class DeviceInfo: Codable {
    public  var btAddress: String?
    public var btNameModel: DeviceInfoBtNameModel?
    public var creekDevType: Int? = 0
    public var creekShape: Int? = 0
    public var deviceBatteryModel: DeviceInfoBatteryModel?
    public var deviceId: Int? = 0
    public var deviceSizeModel: DeviceInfoSizeModel?
    public var fontMajorVersion: Int? = 0
    public var fontMicroVersion: Int? = 0
    public var fontMinorVersion: Int? = 0
    public var hardwareSupportModel: DeviceInfoHardwareSupportModel?
    public var isRecoveryMode: Bool? = false
    public var macAddress: String?
    public var majorVersion: Int? = 0
    public var microVersion: Int? = 0
    public var minorVersion: Int? = 0
    public var pairFlag: Int? = 0
    public  var platform: String?
    public var rebootFlag: Int? = 0
}

public class DeviceInfoSizeModel: Codable {
    public var angle: Int? = 0
    public var height: Int? = 0
    public var width: Int? = 0
}

public class DeviceInfoBatteryModel: Codable {
    public var batteryLevel: Int? = 0
    public var batteryModel: Int? = 0
    public var batteryStatus: Int? = 0
    public var lastChargingDay: Int? = 0
    public var lastChargingHour: Int? = 0
    public var lastChargingMinute: Int? = 0
    public var lastChargingMonth: Int? = 0
    public var lastChargingSecond: Int? = 0
    public var lastChargingYear: Int? = 0
    public var voltage: Int? = 0
}

public class DeviceInfoBtNameModel: Codable {
    public var isSupport: Bool? = false
    public var name: String?
}

public class DeviceInfoHardwareSupportModel: Codable {
    public var accHardware: Bool? = false
    public var buttonHardware: Bool? = false
    public var gpsHardware: Bool? = false
    public  var gyroHardware: Bool? = false
    public var heartRateHardware: Bool? = false
    public  var lcdHardware: Bool? = false
    public  var micHardware: Bool? = false
    public var motorHardware: Bool? = false
    public var nAndFlashHardware: Bool? = false
    public var norFlashHardware: Bool? = false
    public var speakHardware: Bool? = false
    public var tpHardware: Bool? = false
}
