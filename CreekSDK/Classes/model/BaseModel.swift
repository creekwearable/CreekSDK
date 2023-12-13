//
//  baseModel.swift
//  CreekSDK
//
//  Created by bean on 2023/7/8.
//

import Foundation

public class BaseModel<T:Codable>: Codable {
    
    ///error code
    public var code: Int?
    
    ///optional data type
    public var data: T?
    
    ///Message content
    public var msg: String?
    
}



public class BaseDataModel: Codable {

}
