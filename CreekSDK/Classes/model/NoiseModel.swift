//
//  NoiseModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation

public class NoiseModel: Codable {
    ///average Noise
    public var average: Int?
    ///time
    public var creat_time: String?
    public var datas : [NoiseDataModel]?
//    public var deviceId: String?
    public var id: Int?
    /// maximum Noise
    public var max: Int?
    /// minimum Noise
    public var min: Int?
    ///The time when the last piece of data was generated     unit /m
    public var offset_last: Int?
    public var userID: Int?
    public var uploadStatus: Int?
}

public class NoiseDataModel: Codable {
    ///Starting from 0, the offset from the previous value   unit /m
    public var offset: Int?
    ///Noise value
    public var value: Int?
}
