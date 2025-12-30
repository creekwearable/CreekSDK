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
   ///emperature data magnified 100 times, retain two decimal places / degree
   public var bodyTemp: Int?
   ///Whether to support average sleeping temperature data 0 Not supported 1 Supported
   public var bodyTempSupport: Int?
   ///Whether to take a nap
   public var isNapSleep: Int?
   ///Does the OSA data support (ahi_value, apnoea_value, spo2_value)?
   public var osaSupport: Int?
   public var ahiValue: Int?
   ///Number of suspected breathing apneas
   public var apnoeaValue: Int?
   ///Nighttime Real-time Blood Oxygen Levels
   public var spo2Value: Int?
   
   /// NEW: Whether device supports sleep health data
   public var healthDataSupport: Int?
   
   /// NEW: SpO2 min during sleep
   public var spo2MinValue: Int?
   
   /// NEW: SpO2 max during sleep
   public var spo2MaxValue: Int?
   
   /// NEW: Avg heart rate during sleep
   public var heartRateAverageValue: Int?
   
   /// NEW: Min heart rate during sleep
   public var heartRateMinValue: Int?
   
   /// NEW: Max heart rate during sleep
   public var heartRateMaxValue: Int?
   
   /// NEW: HRV average
   public var hrvAverageValue: Int?
   
   /// NEW: HRV min
   public var hrvMinValue: Int?
   
   /// NEW: HRV max
   public var hrvMaxValue: Int?
   
   /// NEW: respiration average
   public var respirationRateAverageValue: Int?
   
   /// NEW: respiration min
   public var respirationRateMinValue: Int?
   
   /// NEW: respiration max
   public var respirationRateMaxValue: Int?
   
   /// NEW: in/out bed feature support 0/1
   public var inOutBedDataSupport: Int?
   
   /// NEW: in-bed timestamp
   public var inBedTimestamp: Int?
   
   /// NEW: minimal in-bed duration (minutes)
   public var inBedDurationMin: Int?
   
   /// NEW: out-of-bed timestamp
   public var outBedTimestamp: Int?
   
   /// NEW: minimal out-of-bed duration (minutes)
   public var outBedDurationMin: Int?

   /// Average stress value during sleep
   public var stressAverageValue: Int?

   /// Minimum stress value during sleep
   public var stressMinValue: Int?

   /// Maximum stress value during sleep
   public var stressMaxValue: Int?

   /// Whether training readiness is supported
   public var readinessSupport: Bool?

   /// Training readiness score
   public var readinessScore: Int?

   /// Total duration with SpO2 below 90% (minutes)
   public var spo2BelowDuration: Int?

   /// Oxygen Desaturation Index (ODI) value
   public var odiValue: Int?

   /// Oxygen desaturation event count (OSA event count)
   public var osaEventCount: Int?

   /// Count of oxygen drops with a decrease ≥ 4
   public var maxDrop4Cnt: Int?

   public var datas : [SleepDataModel]?
}

public class SleepDataModel: Codable {
   ///sleep stage
   public var stage: health_storage_sleep_stage_type?
   ///Starting from 0, the offset from the previous value   unit /m
   public var duration: Int?
}
