//
//  RespiratoryModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/10/23.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

public class RespiratoryModel: Codable {
    ///average respiratory
    public var average: Int?
    ///time
    public var create_time: String?
    public var datas : [RespiratoryDataModel]?
    public var id: Int?
    /// maximum respiratory
    public var max: Int?
    /// minimum respiratory
    public var min: Int?
    ///The time when the last piece of data was generated     unit /m
    public var offset_last: Int?
    public var userID: Int?
    public var uploadStatus: Int?
}

public class RespiratoryDataModel: Codable {
    ///Unit/minute
    public var offset: Int?
    ///respiratory value
    public var value: Int?
}
