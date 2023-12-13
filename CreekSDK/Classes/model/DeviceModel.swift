//
//  File.swift
//  CreekSDK
//
//  Created by bean on 2023/7/3.
//

public class ScanDeviceModel:Codable{
    
    public var device:DeviceModel?
    
    ///Signal
    public var rssi:Int?
    public var firmwareId:Int?
    public var macAddress:String?
    public var deviceColor:Int?
    ///Last binding status
    public var lastBind:Bool?

}

public class DeviceModel:Codable{
    public var id:String?
    public var name:String?
    public var type:Int?
    
}
