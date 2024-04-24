//
//  EphemerisGPSModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2024/4/23.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public class EphemerisGPSModel: Codable {
    
    /// Is the location valid?
    public var isVaild:Bool?

    /// Latitude magnified 100000 times
    public var latitude:Int?

    /// Longitude magnified 100000 times
    public var longitude:Int?

    ///Altitude, unit meter
    public var altitude:Int?
    
    public init(isVaild: Bool? = nil, latitude: Int? = nil, longitude: Int? = nil, altitude: Int? = nil) {
        self.isVaild = isVaild
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }


}
