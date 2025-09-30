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
    public var deviceId: String?
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
   
   /// Whether speed details are supported
   public var speedPaceSupport: Int?

   /// Whether total resting calories are supported
   public var restCaloriesSupport: Int?

   /// Total resting calories
   public var totalRestCalories: Int?

   /// Whether VO2max and running power index are supported
   public var vo2maxSupport: Int?

   /// Whether swimming data is supported
   public var swimDataSupport: Int?

   /// Pool length (in meters)
   public var poolLength: Int?

   /// Pool length (in yards)
   public var yardPoolLength: Int?

   /// Number of swim laps
   public var totalLaps: Int?

   /// Main swimming stroke
   public var mainStroke: Int?

   /// Total number of strokes
   public var totalStrokes: Int?

   /// Average swimming pace
   public var swimAvgPace: Int?

   /// Swimming SWOLF = strokes per lap + time per lap (seconds)
   public var swimAvgSwolf: Int?

   /// Average stroke rate
   public var avgStrokeRate: Int?

   /// Whether paused duration is supported
   public var pauseDurationsSupport: Int?

   /// Whether workout course is supported
   public var workoutCourseSupport: Int?

   /// Total workout course duration (seconds)
   public var courseTotalDurations: Int?

   /// Total workout course distance (meters)
   public var courseTotalDistance: Int?

   /// Total workout course calories
   public var courseTotalCalories: Int?

   /// Workout course ID
   public var courseId: Int?

   /// Workout course paused duration (seconds)
   public var coursePauseDurations: Int?

   /// Workout course name
   public var courseName: String?
   
   /// Whether multi-sport is supported
   public var multiSportSupport: Int?

   /// Multi-sport index
   public var multiSportIndex: Int?

   /// Total number of multi-sports
   public var multiSportCount: Int?

   /// Whether this is the last one
   public var multiSportIsLastOne: Int?

   /// Total duration of multi-sport
   public var multiSportTotalDurations: Int?

   /// Total distance of multi-sport
   public var multiSportTotalDistance: Int?

   /// Total calories of multi-sport
   public var multiSportTotalCalories: Int?

   /// Total active calories of multi-sport
   public var multiSportActiveCalories: Int?

   /// Average heart rate of multi-sport
   public var multiSportAvgHr: Int?
   /// Multi-sport ID
   public var multiSportId: Int?
   
   public var workoutCourseItem : [WorkoutCourseModel]?
   
   public var sportLapItem : [SportLapModel]?
   ///Power details
   public var powerItem : [Int]?
   ///Does it support swimming heart rate?
   public var swimHrSupport: Int?
   ///Whether to support swimming tracks
   public var swimTrailSupport: Int?
   ///Whether to support real-time pacing, speed
   public var rtKmSpeedPaceSupport: Int?
   ///Does it support expanding the speed unit by 100 times to be compatible with previous data types?
   public var speedUnit100: Int?
   ///Whether to support swimming time
   public var swimDurationSupport: Int?
   ///swimming time
   public var swimDurations: Int?
   ///Whether to support mile distance
   public var miDistanceSupport: Int?
   ///Average mile pace is transmitted in seconds, for example, 361 361/60=6 minutes, the remainder is 1s 6''1'
   public var avgMiPace: Int?
   ///Fastest mile pace
   public var fastMiPace: Int?
   ///Average speed in miles per hour (mi/h) Firmware scaled up 100 times
   public var avgMiSpeed: Int?
   ///Fastest mile speed mi/h firmware expanded 100 times
   public var fastMiSpeed: Int?
   ///Whether to support swimming distance unit (yards)
   public var swimDistanceSupport: Int?
   ///Swimming distance Unit: yards
   public var swimYardDistance: Int?
   ///Football distance support display
   public var footballDistanceSupport: Int?
   
   
}

public class SportDataModel: Codable {
    
    public var latitude: Int?
    public var longitude: Int?
}

public class SpeedPaceModel: Codable {
    
    public var speed: Int?
    public var pace: Int?
}

public class WorkoutCourseModel: Codable {
    
    /// Duration of the phase
    public var durations: Int?

    /// Type of sport
    public var type: Int?

    /// Start time
    public var startTime: String?

    /// Name
    public var name: String?

    /// Continuing target type   continuing_target（enum）
    public var ctType: Int?

    /// Strength target type    strength_target（enum）
    public var stType: Int?

    /// Continuing target value
    public var ctValue: Int?

    /// Maximum strength target value
    public var stMax: Int?

    /// Minimum strength target value
    public var stMin: Int?

    /// Average strength value, derived from the strength target type
    public var avgStValue: Int?

    /// Maximum extreme strength value
    public var extremeValueMax: Int?

    /// Minimum extreme strength value
    public var extremeValueMin: Int?

    /// Completion rate, two decimal places retained, actual value multiplied by 100
    public var completeRate: Int?
   
    ///step type
    public var steptype: Int?
   
}

public class SportLapModel: Codable {
    /// Duration of exercise
    public var durations: Int?
   /// Average pace (min/km) or speed for cycling; for other sports, this is pace
    public var avgKmPace: Int?
   /// Average pace (min/mi) or speed for cycling; for other sports, this is pace
    public var avgMiPace: Int?
   /// Average power
    public var avgPower: Int?
   /// Distance (meters)
    public var distance: Int?
   /// Average heart rate value
    public var avgHrValue: Int?
   /// Maximum heart rate value
    public var maxHrValue: Int?
   /// Minimum heart rate value
    public var minHrValue: Int?
   /// Calories
    public var calories: Int?

}
