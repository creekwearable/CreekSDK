//
//  EventReport.swift
//  CreekSDK
//
//  Created by bean on 2023/10/21.
//

import Foundation

public class EventReportModel: Codable {
    
    ///事件id
    public var eventId: String?
    
    ///事件子id
    public var subId: String?
    
    ////事件产生时间
    public var time: String?
    
    ///消息体
    public var message: String?
    
}
