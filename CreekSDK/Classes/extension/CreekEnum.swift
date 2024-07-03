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


public enum SportType : Int , Codable
{
    static var defaultCase: SportType {
        .ORUN
    }
    case ORUN  = 0                        //outdoor running
    case IRUN = 1                         //indoor running
    case OWALK = 2                        //walk outdoors
    case IWALK = 3                        //indoor walk
    case  HIKING = 4                      //on foot
    case OCYCLE = 5                       //outdoor riding
    case  ICYCLE = 6                      //indoor cycling
    case  CRICKET = 7                     //cricket
    case  FOOTBALL = 8                    //football
    case PSWIM = 9                        //swimming pool
    case OSWIM = 10                       //open area swimming
    case  YOGA = 11                       //yoga
    case PILATES = 12                     //Pilates
    case DANCE = 13                       //Dance
    case ZUMBA = 14                       //Zumba
    case ROWER = 15                       //rowing machine
    case  ELLIPTICAL = 16                 //elliptical machine
    case  CTRAINING = 17                   //core training
    case  TSTRAINING = 18                   //traditional strength training
    case  FSTRAINING = 19                   //functional strength training
    case  HIIT = 20                         //HIIT
    case COOLDOWN = 21                     //Tidy up and relax
    case WORKOUT = 22                      //free training
    case FITNESS = 23                      //fitness
    case TRAIL_RUNNING = 24                 //Trail running
    
    // 健身
    case TREADMILL = 25                    //Stepper
    case AEROBICS = 26                     //Aerobics
    case SIT_UP = 27                       //Sit-ups
    case PLANK = 28                        //Plank
    case JUMPING_JACK = 29                 //Jackpot
    case  CHIN_UP = 30                      //pull up
    case PUSH_UP = 31                      //push ups
    case  DEEP_SQUAT = 32                   //squat
    case HIGH_KNEE_LIFT = 33               //high leg
    case DUMBBELL = 34                     //dumbbel
    case BARBELL = 35                      //barbell
    case BOXING = 36                       //boxing
    case KICKBOXING = 37                   //free sparring
    case  HORIZONTAL_BAR = 38               //horizontal bar
    case PARALLEL_BARS = 39                //parallel bars
    case WALKING_MACHINE = 40              //walking machine
    case SUMMIT_TRAINERS = 41              //climbing machine
    
    /*球类*/
    case  BOWLING = 42                      //bowling
    case TENNIS = 43                       //tennis
    case TABLE_TENNIS = 44                 //pingpong
    case GOLF = 45                         //golf
    case BASKETBALL = 46                   //basketball
    case  BADMINTON = 47                    //badminton
    case HOCKEY = 48                       //hockey
    case RUGBY = 49                        //football
    case HANDBALL = 50                     //handball
    case SQUASH = 51                       //squash
    case BASEBALL = 52                     //baseball
    case  SOFTBALL = 53                     //softball
    case SHUTTLECOCK = 54                  //shuttlecock
    case SEPAKTAKRAW = 55                  //sepak takraw
    
    /*休闲运动*/
    case  STREET_DANCE = 56                 //street dance
    case  MOUNTAIN_CLINBING = 57            //mountaineering
    case  ROPE_SKIPPING = 58                //jump rope
    case  CLIMB_STAIRS = 59                 //climbing stairs
    case  BALLET = 60                       //ballet
    case  SOCIAL_DANCE = 61                 //social dance
    case  DARTS = 62                        //darts
    case HORSEBACK_RIDING = 63             //horse riding
    case ROLLER_SKATING = 64               //roller skating
    case  TAI_CHI = 65                      //Tai Chi
    case  FRISBEE = 66                      //Frisbee
    case  HULA_HOOP = 67                    //Hula Hoop
    
    /*冰雪运动*/
    case  SLEIGH = 68                       //sled
    case SKATING = 69                      //skate
    case  BOBSLEIGH_AND_TOBOGGANING = 70    //snowmobile
    case CURLING = 71                      //Curling
    case ICE_HOCKEY = 72                   //puck
    
    /*水上运动*/
    case  SURFING = 73                      //surf
    case  SAILBOAT = 74                     //sailboat
    case SAILBOARD = 75                    //windsurfing
    case  FOLDBOATING = 76                  //kayak
    case CANOEING = 77                     //rowing
    case BOAT_RACE = 78                    //rowing
    case MOTORBOAT = 79                    //motor boat
    case WATER_POLO = 80                   //water polo
    
    /*极限运动*/
    case  SLIDING_PLATE = 81                //skateboard
    case  ROCK_CLIMBING = 82                //rock climbing
    case BUNGEE_JUMPING = 83                //bungee jumping
    case PARKOUR = 84                       //Parkour
    case OTHER = 85                         //other
    
    /*Add new sports*/
    case    SPINNING = 86; //Spinning bike
    case     MARTIAL_ARTS = 87; //Martial Arts
    case    TAEKWONDO = 88; //Taekwondo
    case    KARATE = 89; //Karate
    case    GYMNASTICS = 90; //gymnastics
    case     PADEL = 91; //cage tennis
    case    PICKLEBALL = 92; //pickleball
    case    SNOWBOARDING = 93; //Snowboarding
    case    SKIING = 94; //Skiing
    case     PADDLING = 95; //Paddle
    case     BMX = 96; //BMX
    case    FENCING = 97; //Fencing
    case    BILLIARDS = 98; //Billiards
    case    BEACH_SOCCER = 99; //Beach Soccer
    case    BEACH_VOLLEYBALL = 100; //Beach volleyball
    case    DODGEBALL = 101; //Dodgeball
    case    JAZZ = 102; //Jazz dance
    case     LATIN = 103; //Latin dance
    case    SQUARE_DANCE = 104; //Square dance
    case    VOLLEYBALL = 105; //Volleyball
    case   KITE_FLYING = 106; //Kite flying
    case    FISHING = 107; //Fishing
    case     ARCHERY = 108; //Archery
    case     SHOOTING = 109; //shooting
    case    WHITE_WATER_RAFTING = 110; //Rafting
    case    ALPINE_SKIING = 111; //Alpine skiing
    case    CROSS_COUNTRY_SKIING = 112; //cross-country skiing
    case    BIATHON = 113; //biathlon
    case    DRAGON_BOAT_RACING = 114; //Dragon boat
    case   RACING = 115; //racing
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

