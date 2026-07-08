//
//  NoiseModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation

public class ActivityLevelModel: Codable {
   
    ///time
    public var create_time: String?
    public var datas : [ActivityLevelDataModel]?
//    public var deviceId: String?
    public var id: Int?
    ///The time when the last piece of data was generated     unit /m
    public var offset_last: Int?
    public var userID: Int?
    public var uploadStatus: Int?
}

public class ActivityLevelDataModel: Codable {
    ///Starting from 0, the offset from the previous value   unit /m
    public var offset: Int?
    ///Activity Level
    public var activityLevelMinAvg: Int?
}
