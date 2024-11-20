//
//  ContactsIconModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/8/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation


public class ContactsIconModel: Codable {
   /// telephone number
    public var phoneNum: String?
   /// Local path of the image
    public var path: String?
   /// Width of the image
    public var w: Int?
   /// height of the image
    public var h: Int?
   ///Image compression quality, minimum 10~100
    public var quality: Int?
   ///Does the firmware support parsing lz4 algorithm compression?
    public var isLz4: Int?
   
   init(phoneNum: String? = nil, path: String? = nil, w: Int? = nil, h: Int? = nil, quality: Int? = nil, isLz4: Int? = nil) {
      self.phoneNum = phoneNum
      self.path = path
      self.w = w
      self.h = h
      self.quality = quality
      self.isLz4 = isLz4
   }
   
    
    
}
