//
//  AfPpgModel.swift
//  CreekSDK_Example
//
//  Created by bob on 2025/9/26.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

public struct CreekAfPpgModel: Codable, CustomStringConvertible {
    var id: Int?
    var userID: Int?
    var deviceId: String?
    var createTime: String?
    var firmwareVersion: String?
    var firmwareId: Int?
    var offsetLast: Int?
    var offsetLastTime: String?
    var values: [Int]?

    var description: String {
        return """
        CreekAfPpgModel(id: \(id ?? 0), userID: \(userID ?? 0), deviceId: \(deviceId ?? "nil"), \
        createTime: \(createTime ?? "nil"), firmwareVersion: \(firmwareVersion ?? "nil"), \
        firmwareId: \(firmwareId ?? 0), offsetLast: \(offsetLast ?? 0), \
        offsetLastTime: \(offsetLastTime ?? "nil"), values: \(values ?? []))
        """
    }

    static func toThis() -> String {
        return "CreekAfPpgModel"
    }
}
