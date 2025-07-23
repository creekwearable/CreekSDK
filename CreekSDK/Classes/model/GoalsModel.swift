//
//  GoalsModel.swift
//  CreekSDK_Example
//
//  Created by bean on 2025/7/23.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit

public class GoalsModel: Codable {
    /// Calories (default 350)
    public var calories: Int? = 350
    /// Exercise duration (minutes, default 30)
    public var exercise: Int? = 30
    /// Standing hours (default 8)
    public var stand: Int? = 8
    /// Steps (default 8000)
    public var steps: Int? = 8000
    /// Distance in meters (default 5000)
    public var distance: Int? = 5000

    public init(
        calories: Int? = 350,
        exercise: Int? = 30,
        stand: Int? = 8,
        steps: Int? = 8000,
        distance: Int? = 5000
    ) {
        self.calories = calories
        self.exercise = exercise
        self.stand = stand
        self.steps = steps
        self.distance = distance
    }
}

