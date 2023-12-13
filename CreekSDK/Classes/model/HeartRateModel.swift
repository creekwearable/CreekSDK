//
//  HeartRateModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation


public class HeartRateModel: Codable {
    ///average heart rate
    public var average: Int? = 0
    ///time
    public var creat_time: String?
    public var datas : [HeartRateDataModel]?
    
   // public var deviceId: String?
    
    /*
     5 heart rate zones, namely
          warm-up zone
          Fat Burning Heart Rate Zone
          Aerobic endurance heart rate zone
          Anaerobic endurance heart rate zone
          limit heart rate zone
     */
    
//    public var hr_interval: String?
    public var id: Int?
    ///maximum heart rate
    public var max: Int?
    ///minimum heart rate
    public var min: Int?
    ///The time when the last piece of data was generated     unit /s
    public var offset_last: Int?
    
    ///Increased heart rate ratio    0-100
    public var raisedHr: Int?
    ///resting heart rate
    public var silent_hr: Int?
    public var userID: Int?
    public var uploadStatus: Int?
}

public class HeartRateDataModel: Codable {
    ///Starting from 0, the offset from the previous value   unit /s
    public var offset: Int?
    ///heart rate value
    public var value: Int?
}
