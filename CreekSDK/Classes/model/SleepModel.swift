//
//  SleepModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation

public class SleepModel: Codable {

    public var id: Int?
    public var userID: Int?
//    public var deviceId: String?
    ///wake up time  y-m-d
    public var get_up_date: String?
    ///fall asleep time  y-m-d  h:m:s
    public var fall_asleep_time: String?
    ///wake up time y-m-d  h:m:s
    public var get_up_time: String?
    ///Total sleep duration
    public var total_sleep_time_mins: Int?
    ///Sleep stage - total waking time, Unit: minute
    public var wake_mins: Int?
    ///Sleep stage - total light sleep duration Unit: minute
    public var light_sleep_mins: Int?
    ///Sleep stage - total deep sleep duration Unit: minute
    public var deep_sleep_mins: Int?
    ///Sleep stage - total REM duration unit: minutes
    public var rem_mins: Int?
    
    ///Waking times
    public var wake_count: Int?
    ///light sleep times
    public var light_sleep_count: Int?
    ///deep sleep times
    public var deep_sleep_count: Int?
    ///Eye movements
    public var rem_count: Int?
    ///sleep score
    public var sleep_score: Int?
    public var uploadStatus: Int?
    public var datas : [SleepDataModel]?
}

public class SleepDataModel: Codable {
    ///sleep stage
    public var stage: health_storage_sleep_stage_type?
    ///Starting from 0, the offset from the previous value   unit /m
    public var duration: Int?
}
