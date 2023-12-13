//
//  ActivityModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/2.
//

import Foundation


public class ActivityModel: Codable {
    
    ///Number of activities
    public  var activity_item_count: Int? = 0
    ///Activity time
    public  var creat_time: String?
//    public  var deviceId: String?
    public  var id: Int? = 0
    
//    public  var offset_last: String?
    ///total active calories
    public  var total_activity_calories: Int? = 0
    
    /// Total distance  /m
    public  var total_distances: Int? = 0
    ///Exercise duration in minutes
    public  var total_exercise_min: Int? = 0
    ///Total Resting Calories
    public  var total_rest_calories: Int? = 0
    
    ///hours of standing per day
    public var total_stand_hour: Int? = 0
    
    ///total steps
    public  var total_step: Int? = 0
    public  var userID: Int? = 0
    
    ///Whether to support the number of floors
    public  var floors_climbed_support: Int?

    ///Total number of floors climbed
    public  var total_floors_climbed: Int? = 0
    public var uploadStatus: Int?
    
    
    
    ///One data item is generated every 15 minutes the time when the last piece of data is generated can be obtained
    public  var datas: [ActivityDataModel]?
}


public class ActivityDataModel: Codable {
    ///Activity Calories
    public  var activity_calories: Int? = 0
    ///distance  /m
    public  var distance: Int? = 0
    ///Exercise duration /m
    public  var exercise_min: Int? = 0
    
    public var rest_calories: Int? = 0
    ///  stand    /h
    public var stand_time: Int? = 0
    ///Step count
    public var step_count: Int? = 0
    public var wear_time: Int = 0
}
