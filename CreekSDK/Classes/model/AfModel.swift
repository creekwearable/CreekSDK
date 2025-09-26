//
//  AfModel.swift
//  CreekSDK_Example
//
//  Created by bob on 2025/9/26.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

public struct CreekAfModel: Codable, CustomStringConvertible {
    var id: Int?
    var userID: Int?
    var deviceId: String?
    var createTime: String?
    var firmwareVersion: String?
    var firmwareId: Int?
    var offsetLast: Int?
    var offsetLastTime: String?
    var values: [CreekAfValueModel]?

    var description: String {
        return """
        CreekAfModel(id: \(id ?? 0), userID: \(userID ?? 0), deviceId: \(deviceId ?? "nil"), \
        createTime: \(createTime ?? "nil"), firmwareVersion: \(firmwareVersion ?? "nil"), \
        firmwareId: \(firmwareId ?? 0), offsetLast: \(offsetLast ?? 0), \
        offsetLastTime: \(offsetLastTime ?? "nil"), values: \(values ?? []))
        """
    }

    static func toThis() -> String {
        return "CreekAfModel"
    }
}

struct CreekAfValueModel: Codable, CustomStringConvertible {
    var offset: Int?
    var isAf: Int?

    var description: String {
        return "CreekAfValueModel(offset: \(offset ?? 0), isAf: \(isAf ?? 0))"
    }

    static func toThis() -> String {
        return "CreekAfValueModel"
    }
}
