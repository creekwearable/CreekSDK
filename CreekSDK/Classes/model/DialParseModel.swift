//
//  CreekDialParseModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/1/29.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Flutter

public class DialParseModel: Codable {
    ///All background image paths
    public var backgroundImagePaths: [String]?
   ///Select background index
    public var backgroundSelectIndex: Int?
    ///Color List
    public var appColors : [String]?
    ///Select Color index
    public var colorSelectIndex: Int?
    
    public var previewImageBytes: String?
    
    public var functions: [DialFunctionModel]?
        
}


public class DialFunctionModel: Codable {
  
    ///preview
    public var positionImage: String?
    
    ///Currently selected location
    public var selectedIndex: Int?
    
    public var typeModels: [DialTypeModel]?
    
}

public class DialTypeModel: Codable {
   
    ///display name
    public var type: String?
    public var picture: String?
    
    ///Pictures shown 
    public var image : String?
    public var x: Int?
    public var y: Int?
    public var color: String?
    
    
}

