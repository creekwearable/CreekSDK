// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: watchSensor.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct protocol_watch_sensors_operate: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  ///1bytes 心率总开关
  public var heartRateAllSwitch: switch_type = .switchNull

  ///1bytes 血氧总开关
  public var bloodOxygenAllSwitch: switch_type = .switchNull

  ///1bytes 地磁总开关
  public var compassAllSwitch: switch_type = .switchNull

  ///1bytes 气压总开关
  public var baromaterAllSwitch: switch_type = .switchNull

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_watch_sensors_inquire_reply: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  ///1bytes 心率总开关
  public var heartRateAllSwitch: switch_type = .switchNull

  ///1bytes 血氧总开关
  public var bloodOxygenAllSwitch: switch_type = .switchNull

  ///1bytes 地磁总开关
  public var compassAllSwitch: switch_type = .switchNull

  ///1bytes 气压总开关
  public var baromaterAllSwitch: switch_type = .switchNull

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_watch_sensors_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_watch_sensors_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "heart_rate_all_switch"),
    3: .standard(proto: "blood_oxygen_all_switch"),
    4: .standard(proto: "compass_all_switch"),
    5: .standard(proto: "baromater_all_switch"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.heartRateAllSwitch) }()
      case 3: try { try decoder.decodeSingularEnumField(value: &self.bloodOxygenAllSwitch) }()
      case 4: try { try decoder.decodeSingularEnumField(value: &self.compassAllSwitch) }()
      case 5: try { try decoder.decodeSingularEnumField(value: &self.baromaterAllSwitch) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.heartRateAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.heartRateAllSwitch, fieldNumber: 2)
    }
    if self.bloodOxygenAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.bloodOxygenAllSwitch, fieldNumber: 3)
    }
    if self.compassAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.compassAllSwitch, fieldNumber: 4)
    }
    if self.baromaterAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.baromaterAllSwitch, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_watch_sensors_operate, rhs: protocol_watch_sensors_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.heartRateAllSwitch != rhs.heartRateAllSwitch {return false}
    if lhs.bloodOxygenAllSwitch != rhs.bloodOxygenAllSwitch {return false}
    if lhs.compassAllSwitch != rhs.compassAllSwitch {return false}
    if lhs.baromaterAllSwitch != rhs.baromaterAllSwitch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_watch_sensors_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_watch_sensors_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "heart_rate_all_switch"),
    3: .standard(proto: "blood_oxygen_all_switch"),
    4: .standard(proto: "compass_all_switch"),
    5: .standard(proto: "baromater_all_switch"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.heartRateAllSwitch) }()
      case 3: try { try decoder.decodeSingularEnumField(value: &self.bloodOxygenAllSwitch) }()
      case 4: try { try decoder.decodeSingularEnumField(value: &self.compassAllSwitch) }()
      case 5: try { try decoder.decodeSingularEnumField(value: &self.baromaterAllSwitch) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.heartRateAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.heartRateAllSwitch, fieldNumber: 2)
    }
    if self.bloodOxygenAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.bloodOxygenAllSwitch, fieldNumber: 3)
    }
    if self.compassAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.compassAllSwitch, fieldNumber: 4)
    }
    if self.baromaterAllSwitch != .switchNull {
      try visitor.visitSingularEnumField(value: self.baromaterAllSwitch, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_watch_sensors_inquire_reply, rhs: protocol_watch_sensors_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.heartRateAllSwitch != rhs.heartRateAllSwitch {return false}
    if lhs.bloodOxygenAllSwitch != rhs.bloodOxygenAllSwitch {return false}
    if lhs.compassAllSwitch != rhs.compassAllSwitch {return false}
    if lhs.baromaterAllSwitch != rhs.baromaterAllSwitch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
