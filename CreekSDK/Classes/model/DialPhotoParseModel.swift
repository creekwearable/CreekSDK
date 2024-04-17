//
//  DialPhotoParseModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/4/14.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class DialPhotoParseModel: Codable {
    ///Album pictures
    public var photoImagePaths: [String] = []
    ///colors
    public var appColors: [String]?
    ///clock position
    public var clockPositionImagePaths : [String] = []
    ///The coordinates of the currently selected image
    public var photoSelectIndex: Int?
    ///The coordinates of the currently selected color
    public var colorSelectIndexList: [Int] = []
    ///The coordinates of the currently selected clock position
    public var clockPositionSelectIndexList: [Int] = []
    ///preview
    public var previewImageBytes: String?
    
}
