//
//  CourseModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/4/14.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation

public enum CourseFileType: Int, Codable {
    case json = 0
}

public class CourseModel: Codable {
   public var type: CourseFileType?
   public var fileSize: Int?
   public var fileData: Data?
   public var name: String?

   public init(type: CourseFileType? = nil, fileSize: Int? = nil, fileData: Data? = nil, name: String? = nil) {
      self.type = type
      self.fileSize = fileSize
      self.fileData = fileData
      self.name = name
   }
}

