//
//  StressModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation


public class StressModel: Codable {
    ///average stress
    public var average: Int?
    ///time
    public var creat_time: String?
    public var datas : [StressDataModel]?
    public var deviceId: String?
    ///Produces 60 to 79 pressure quantities
    public var higher: Int?
    public var id: Int?
    /// Produces 1 to 29 pressure quantities
    public var low: Int?
    /// maximum Stress
    public var max: Int?
    /// minimum Stress
    public var min: Int?
    ///The time when the last piece of data was generated     unit /m
    public var offset_last: Int?
    public var userID: Int?
    ///Produces 30 to 59 pressure quantities
    public var usual: Int?
    ///Produces 79 to 99 pressure quantities
    public var veryHigh: Int?
    public var uploadStatus: Int?
}

public class StressDataModel: Codable {
    ///Starting from 0, the offset from the previous value   unit /m
    public var offset: Int?
    ///Stress value
    public var value: Int?
}
