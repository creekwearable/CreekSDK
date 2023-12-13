//
//  EphemerisModel.swift
//  CreekSDK
//
//  Created by bean on 2023/10/26.
//

import Foundation

public class EphemerisModel:Codable{
    
    /// gps型号
    public var socName:String?

    /// 开始时间:(UTC 单位秒)
    public var startUtcTime:Int?

    /// 结束时间:(UTC 单位秒)
    public var endUtcTime:Int?

    /// 位置是否有效
    public var isVaild:Bool?

    /// 纬度 放大100000倍
    public var latitude:Int?

    /// 纬度方向 S南纬  N北纬
    public var latitudeDire:String?

    /// 经度 放大100000倍
    public var longitude:Int?

    /// 经度方向 W西经 E东经
    public var longitudeDire:String?

    ///海拔，单位米
    public var altitude:Int?

    /// 星历文件大小
    public var fileSize:Int?

    /// 星历原文件地址
    public var filePath:String?
    
    public init(socName: String? = nil, startUtcTime: Int? = nil, endUtcTime: Int? = nil, isVaild: Bool? = nil, latitude: Int? = nil, latitudeDire: String? = nil, longitude: Int? = nil, longitudeDire: String? = nil, altitude: Int? = nil, fileSize: Int? = nil, filePath: String? = nil) {
        self.socName = socName
        self.startUtcTime = startUtcTime
        self.endUtcTime = endUtcTime
        self.isVaild = isVaild
        self.latitude = latitude
        self.latitudeDire = latitudeDire
        self.longitude = longitude
        self.longitudeDire = longitudeDire
        self.altitude = altitude
        self.fileSize = fileSize
        self.filePath = filePath
    }
    
}
