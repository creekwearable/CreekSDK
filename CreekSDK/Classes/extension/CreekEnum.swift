//
//  CreekEnum.swift
//  CreekSDKDemo
//
//  Created by bean on 2023/7/13.
//

import Foundation

public enum connectionStatus : Int {
    case none           //no equipment
    case connect        //Connected
    case connecting     //Connecting
    case sync           //In sync
    case syncComplete   //Synchronous completion
    case unconnected    //unconnected
    case inTransition   //Switch device connection
}



public enum BindType : Int
{
    case  bindeNcrypted = 0   //Authorization code verification
    case  binNormal           //direct binding
    case  bindRemove          //unbind
    case  bindPairingCode     //Pairing code binding
}


public enum SportType: Int, Codable {
    public static var defaultCase: SportType {
        .ORUN
    }

    case ORUN = 0                        // Outdoor running
    case IRUN = 1                        // Indoor running
    case OWALK = 2                       // Outdoor walking
    case IWALK = 3                       // Indoor walking
    case HIKING = 4                      // Hiking
    case OCYCLE = 5                      // Outdoor cycling
    case ICYCLE = 6                      // Indoor cycling
    case CRICKET = 7                    // Cricket
    case FOOTBALL = 8                   // Football
    case PSWIM = 9                      // Pool swimming
    case OSWIM = 10                     // Open water swimming
    case YOGA = 11                      // Yoga
    case PILATES = 12                   // Pilates
    case DANCE = 13                     // Dance
    case ZUMBA = 14                     // Zumba
    case ROWER = 15                     // Rowing machine
    case ELLIPTICAL = 16                // Elliptical machine
    case CTRAINING = 17                 // Core training
    case TSTRAINING = 18                // Traditional strength training
    case FSTRAINING = 19                // Functional strength training
    case HIIT = 20                      // HIIT
    case COOLDOWN = 21                  // Cooldown
    case WORKOUT = 22                   // Free workout
    case FITNESS = 23                   // Fitness
    case TRAIL_RUNNING = 24             // Trail running
    case TREADMILL = 25                 // Stair machine
    case AEROBICS = 26                  // Aerobics
    case SIT_UP = 27                    // Sit-ups
    case PLANK = 28                     // Plank
    case JUMPING_JACK = 29              // Jumping jacks
    case CHIN_UP = 30                   // Pull-ups
    case PUSH_UP = 31                   // Push-ups
    case DEEP_SQUAT = 32                // Squats
    case HIGH_KNEE_LIFT = 33            // High knees
    case DUMBBELL = 34                  // Dumbbells
    case BARBELL = 35                   // Barbells
    case BOXING = 36                    // Boxing
    case KICKBOXING = 37                // Kickboxing
    case HORIZONTAL_BAR = 38            // Horizontal bar
    case PARALLEL_BARS = 39             // Parallel bars
    case WALKING_MACHINE = 40           // Walking machine
    case SUMMIT_TRAINERS = 41           // Summit trainers
    case BOWLING = 42                   // Bowling
    case TENNIS = 43                    // Tennis
    case TABLE_TENNIS = 44              // Table tennis
    case GOLF = 45                      // Golf
    case BASKETBALL = 46                // Basketball
    case BADMINTON = 47                 // Badminton
    case HOCKEY = 48                    // Hockey
    case AMERICAN_FOOTBALL = 49         // American football
    case HANDBALL = 50                  // Handball
    case SQUASH = 51                    // Squash
    case BASEBALL = 52                  // Baseball
    case SOFTBALL = 53                  // Softball
    case SHUTTLECOCK = 54               // Shuttlecock
    case SEPAKTAKRAW = 55               // Sepaktakraw
    case STREET_DANCE = 56              // Street dance
    case MOUNTAIN_CLINBING = 57         // Mountain climbing
    case ROPE_SKIPPING = 58             // Rope skipping
    case CLIMB_STAIRS = 59              // Stair climbing
    case BALLET = 60                    // Ballet
    case SOCIAL_DANCE = 61              // Social dance
    case DARTS = 62                     // Darts
    case HORSEBACK_RIDING = 63          // Horseback riding
    case ROLLER_SKATING = 64            // Roller skating
    case TAI_CHI = 65                   // Tai chi
    case FRISBEE = 66                   // Frisbee
    case HULA_HOOP = 67                 // Hula hoop
    case SLEIGH = 68                    // Sledding
    case SKATING = 69                   // Ice skating
    case BOBSLEIGH_AND_TOBOGGANING = 70 // Bobsleigh and tobogganing
    case CURLING = 71                   // Curling
    case ICE_HOCKEY = 72                // Ice hockey
    case SURFING = 73                   // Surfing
    case SAILBOAT = 74                  // Sailing
    case SAILBOARD = 75                 // Windsurfing
    case FOLDBOATING = 76               // Kayak
    case CANOEING = 77                  // Canoeing
    case BOAT_RACE = 78                 // Rowing
    case MOTORBOAT = 79                 // Motorboating
    case WATER_POLO = 80                // Water polo
    case SLIDING_PLATE = 81             // Skateboarding
    case ROCK_CLIMBING = 82             // Rock climbing
    case BUNGEE_JUMPING = 83            // Bungee jumping
    case PARKOUR = 84                   // Parkour
    case OTHER = 85                     // Other
    case SPINNING = 86                  // Spinning
    case MARTIAL_ARTS = 87              // Martial arts
    case TAEKWONDO = 88                 // Taekwondo
    case KARATE = 89                    // Karate
    case GYMNASTICS = 90                // Gymnastics
    case PADEL = 91                     // Padel
    case PICKLEBALL = 92                // Pickleball
    case SNOWBOARDING = 93              // Snowboarding
    case ALPINE_SKIING = 94             // Alpine skiing
    case PADDLING = 95                  // Paddling
    case BMX = 96                       // BMX
    case FENCING = 97                   // Fencing
    case BILLIARDS = 98                 // Billiards
    case BEACH_SOCCER = 99              // Beach soccer
    case BEACH_VOLLEYBALL = 100         // Beach volleyball
    case DODGEBALL = 101                // Dodgeball
    case JAZZ = 102                     // Jazz dance
    case LATIN = 103                    // Latin dance
    case SQUARE_DANCE = 104             // Square dance
    case VOLLEYBALL = 105               // Volleyball
    case KITE_FLYING = 106              // Kite flying
    case FISHING = 107                  // Fishing
    case ARCHERY = 108                  // Archery
    case SHOOTING = 109                 // Shooting
    case WHITE_WATER_RAFTING = 110      // White water rafting
    case DOWNHILL_SKIING = 111          // Downhill skiing
    case CROSS_COUNTRY_SKIING = 112     // Cross-country skiing
    case BIATHON = 113                  // Biathlon
    case DRAGON_BOAT_RACING = 114       // Dragon boat racing
    case RACING = 115                   // Racing
    case AUSTRALIAN_RULES_FOOTBALL = 116 // Australian rules football
    case BOULDERING = 117               // Bouldering
    case TRACK_RUNNING = 118            // Track running
    case STANDUP_PADDLEBOARDING = 119   // Stand-up paddleboarding
    case RACQUETBALL = 120              // Racquetball
    case DISC_OLF = 121                 // Disc golf
    case SKIING = 122                   // Skiing
    case INLINE_SKATING = 123           // Inline skating
    case OUTDOOR_FITNESS = 124          // Outdoor fitness
    case SNOW_SKATEBOARDING = 125       // Snow skateboarding
    case CANOE = 126                    // Canoe
    case MIXED_AEROBICS = 127           // Mixed aerobics
    case WEIGHTLIFTING = 128            // Weightlifting
    case ULTIMATE_FRISBEE = 129         // Ultimate frisbee
    case CROSS_TRAINING = 130           // Cross training
    case INTERVAL_TRAINING = 131        // Interval training
    case EQUESTRIAN_SPORTS = 132        // Equestrian sports
    case KAYAKING = 133                 // Kayaking
    case WRESTLING = 134                // Wrestling
    case INDOOR_CLIMBING = 135          // Indoor climbing
    case ATHLETICS = 136                // Athletics
    case STEP_AEROBICS = 137            // Step aerobics
    case PHYSICAL_CONDITIONING = 138    // Physical conditioning
    case RECREATIONAL_SPORTS = 139      // Recreational sports
    case CIRCUIT_TRAINING = 140         // Circuit training
    case SNOW_SPORTS = 141              // Snow sports
    case AEROBIC_EXERCISE = 142         // Aerobic exercise
    case RUGBY = 143                    // Rugby
    case REHEALTHY_TRAINING = 144       // Rehabilitation training
}


public enum Sport_goal_type : Int ,Codable
{
    static var defaultCase: Sport_goal_type {
        .ENUM_SPORT_GOAL_NO_TARGET
    }
    case  ENUM_SPORT_GOAL_NO_TARGET = 0
    case  ENUM_SPORT_GOAL_DURATION
    case  ENUM_SPORT_GOAL_CALORIE
    case  ENUM_SPORT_GOAL_PACE
    case  ENUM_SPORT_GOAL_SPEED
    case  ENUM_SPORT_GOAL_DISTANCE
    case  ENUM_SPORT_GOAL_LAP
    case  ENUM_SPORT_GOAL_SWIM_DISTANCE
}

public enum sport_swim_stroke_type: Int, Codable {
    case STROKE_TYPE_NULL = 0                     // No stroke
    case STROKE_TYPE_FREESTYLE                   // Freestyle
    case STROKE_TYPE_BREASTSTROKE                // Breaststroke
    case STROKE_TYPE_BUTTERFLY_STROKE            // Butterfly stroke
    case STROKE_TYPE_BACKSTROKE                  // Backstroke
    case STROKE_TYPE_INDIVIDUAL_MEDLEY           // Individual medley
    case STROKE_TYPE_INDIVIDUAL_OTHER            // Other
}


public enum Authorization : Int
{
    case  none = 0
    case  verify
    
}

public enum health_storage_sleep_stage_type : Int, Codable
{
    static var defaultCase: health_storage_sleep_stage_type {
        .SLEEP_STAGE_TYPE_NULL
    }
    case SLEEP_STAGE_TYPE_NULL   = 0
    case SLEEP_STAGE_TYPE_WEEK   = 1   //Sleep Stages - Waking
    case SLEEP_STAGE_TYPE_LIGHT  = 2   //Sleep Stages - Light Sleep
    case SLEEP_STAGE_TYPE_DEEP   = 3   //Sleep Stages - Deep Sleep
    case SLEEP_STAGE_TYPE_REM    = 4   //Sleep Stages - REM
};


public enum eventIdType : Int ,Codable
{
    static var defaultCase: eventIdType {
        .EVENT_ID_NULL
    }
    case EVENT_ID_NULL = 0
    case EVENT_ID_MUSIC_CONTROL = 1//音乐控制
    case EVENT_ID_FINE_PHONE = 2 //寻找手机
    case EVENT_ID_SYNC_DATA = 3//通知更新数据
    case EVENT_ID_FINE_WATCH = 4//寻找手表
}

public enum SyncServerType : Int{
    case activity
    case hearRate
    case noise
    case pressure
    case sleep
    case spo
    case sport
    case hrv
}

public enum PlatformType : Int{
    case JX_3085C_PLATFORM
    case JX_3085L_PLATFORM
    case JX_3085E_PLATFORM
}

public enum BluetoothState : Int {

   case unknown //State unknown, update imminent.
   case unauthorized //The application is not authorized to use the Bluetooth Low Energy role
   case on    //Bluetooth is currently powered on and available to use.
   case off   //Bluetooth is currently powered off
}


public enum CreekClientType : Int{
    case none
    case titan
   
}

public enum CancelAutoConnectType : Int{
    case auto
    case cancel
   
}
public enum continuing_target: Int, Codable {
    case CONTINUING_TARGET_MANUALLY_LAP = 0      // Continuing target - Manually lap
    case CONTINUING_TARGET_TIME = 1              // Continuing target - Time
    case CONTINUING_TARGET_DISTANCE = 2          // Continuing target - Distance
    case CONTINUING_TARGET_CALORIES = 3          // Continuing target - Calories
}

public enum strength_target: Int, Codable {
    case STRENGTH_TARGET_OPEN = 0                // Strength target - Open
    case STRENGTH_TARGET_PACE = 1                // Strength target - Pace
    case STRENGTH_TARGET_CADENCE = 2             // Strength target - Cadence
    case STRENGTH_TARGET_HEART_RATE_ZONE = 3     // Strength target - Heart rate zone
    case STRENGTH_TARGET_CUSTOM_RATE_ZONE = 4    // Strength target - Custom heart rate zone
    case STRENGTH_TARGET_POWER_ZONES = 5         // Strength target - Power zone
}



