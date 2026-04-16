//
//  TemperatureModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2026/4/16.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit

public class TemperatureModel: Codable {
   
    /// Identifier
    public var id: Int?

    /// User ID
    public var userID: Int?

    /// Device ID
    public var deviceId: String?

    /// Creation time
    public var create_time: String?

    /// Firmware version
    public var firmwareVersion: String?

    /// Firmware ID
    public var firmwareId: Int?

    /// Offset time (minutes)
    public var offset_last: Int?

    /// Whether body temperature baseline is supported
    public var bodyLineSupport: Int?

    /// Body temperature baseline value
    public var bodyBaseLineTemp: Int?

    /// Baseline difference
    public var baselineDiff: Int?

    /// Temperature state
    public var tempState: Int?
   
    public var uploadStatus: Int?

    /// Temperature values list
    public var datas: [TemperatureDataModel]?

}

public class TemperatureDataModel: Codable {
   
    /// Offset (minutes)
    public var offset: Int?

    /// Internal temperature
    public var ntc1: Int?

    /// Ambient temperature
    public var ntc2: Int?

    /// Body temperature
    public var bodyTemp: Int?
}
