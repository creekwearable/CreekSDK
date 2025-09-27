//
//  AfModel.swift
//  CreekSDK_Example
//
//  Created by bob on 2025/9/26.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

public class CreekAfModel: Codable {
   public var id: Int?
   public var userID: Int?
   public var deviceId: String?
   public var creat_time: String?
   public var firmwareVersion: String?
   public var firmwareId: Int?
   public var offset_last: Int?
   public var uploadStatus: Int?
   public var datas: [CreekAfValueModel]?
}

public class CreekAfValueModel: Codable{
   public var offset: Int?
   public var isAf: Int?
}
