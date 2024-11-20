//
//  SportModel.swift
//  CreekSDK
//
//  Created by bean on 2023/8/3.
//

import Foundation


public class SportModel: Codable {
    ///Cumulative duration of aerobic exercise  unit/s
    public var aerobicExerciseTime: Int?
    ///Cumulative duration of anaerobic exercise  unit/s
    public var anaerobicExerciseTime: Int?
    ///average heart rate
    public var avgHrValue: Int?
    ///Average Kilometer Pace
    /*
     For example, 361 361/60=6 points, the remainder is 1s 6''1'
     */
    public var avgKmPace: Int?
    ///fastest kilometer pace
    public var fastKmPace: Int?
    ///Average Speed km/h Firmware Expanded 100 Times
    /*
     123 / 100   1.23km/h
     */
    public var avgSpeed: Int?
    ///Maximum speed km/h
    public var fastSpeed: Int?
    ///Average cadence steps/minute
    public var avgStepFrequency: Int?
    ///average stride length
    public var avgStepStride: Int?
    ///time
    public var creatTime: String?
    //    public var deviceId: String?
    ///Exercise duration; unit: s
    public var durations: Int?
    ///start Time y-m-d h:m:s
    public var startTime: String?
    ///End Time y-m-d h:m:s
    public var endTime: String?
    ///Cumulative duration of extreme workout seconds
    public var extremeExerciseTime: Int?
    ///Cumulative duration of fat burning  /s
    public var fatBurningTime: Int?
    public var goalData: Int?
    ///sport goal
    public var goalType: Sport_goal_type?
    ///VO2 rating 0: No rating 1: Low 2: Amateur 3: Average 4: Average
    public var grade: Int?
    ///the number of heart rates
    public var hrItemCount: Int?
    ///Real-time exercise heart rate saves a group every 5 seconds, and saves up to 20 hours
    public var hrValueItem : [Int]?
    public  var id: Int?
    ///No connection app 1 is connected, 0 is not connected
    public var isConnectApp: Int?
    ///实时配速详情 每达到1公里时存一次 单位/s
    public var kmPaceItem : [Int]?
    ///Number of kilometers paced
    public var kmSpeedCount: Int?
    ///Real-time kilometer speed details Save once every 1 kilometer, unit km/h
    /// The actual value is magnified by a hundred times
    /// For example, 12.34km/h, the actual value is 1234
    public var kmSpeedItem : [Int]?
    ///maximum heart rate
    public var maxHrValue: Int?
    ///Maximum stride frequency steps/minute
    public var maxStepFrequency: Int?
    ///maximum stride
    public var maxStepStride: Int?
    ///minimum heart rate
    public var minHrValue: Int?
    ///Real-time mile pace details Save every mile   unit/s
    public var miPaceItem : [Int]?
    ///Real-time mile speed details Save every mile Miles/h
    ///The actual value is magnified by a hundred times
    public var miSpeedItem : [Int]?
    public var elevationItem : [Int]?
    public var paceCount: Int?
    ///Recovery time in hours
    public var recoveryTime: Int?
    ///0: invalid, 1: movement initiated by app, 2: movement initiated by watch
    public var sportStartType: Int?
    ///sportType
    public var sportType: SportType?
    public var stepFrequencyCount: Int?
    ///Real-time cadence details Stored every 5 seconds Steps/minute
    public var stepFrequencyItem : [Int]?
    public var stepStrideCount: Int?
    ///Real-time stride saved once every 5S
    public var stepStrideItem : [Int]?
    /// calories Unit: kcal
    public var totalCalories: Int?
    ///distance; unit: m
    public var totalDistance: Int?
    ///Step count
    public var totalStep: Int?
    ///Movement track
    public var trailData : [SportDataModel]?
    public var speedPaceItem : [SpeedPaceModel]?
    public var trainingEffect: Int?
    public var userID: Int?
    ///VO2 max; unit: ml/kg/min; range 0-80
    public var vozmax: Int?
    ///Cumulative duration of warm-up exercise unit/s
    public var warmUpTime: Int?
    public var uploadStatus: Int?
    
    ///Running power
    public var avgPower: Int?
    
    ///Swimming distance unit: meters
    public var swimDistance: Int?
    
    ///Maximum altitude
    public var maxElevation: Int?
    
    ///Minimum altitude
    public var minElevation: Int?
    
    ///Average altitude
    public var avgElevation: Int?
    ///Climb height
    public var climbHeight: Int?
    ///Met
    public var met: Int?
    ///Whether it supports Met
    
    public var metSupport: Int?
    
    ///Whether altitude data is supported
    public var elevationSupport: Int?
    
    ///Whether running power is supported
    public var avgPowerSupport: Int?
    
    ///Cycle movement duration s
    public var travelingTime: Int?
    
    ///Whether to support cycling movement duration
    public var travelingTimeSupport: Int?
   
    ///Paused exercise duration
    public var pauseDurations: Int?
}

public class SportDataModel: Codable {
    
    public var latitude: Int?
    public var longitude: Int?
}

public class SpeedPaceModel: Codable {
    
    public var speed: Int?
    public var pace: Int?
}
