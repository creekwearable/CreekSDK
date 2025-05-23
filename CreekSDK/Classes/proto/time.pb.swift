// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: time.proto
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

public struct protocol_time: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///2bytes
  public var year: UInt32 = 0

  ///1bytes
  public var month: UInt32 = 0

  ///1bytes
  public var day: UInt32 = 0

  ///1bytes
  public var hour: UInt32 = 0

  ///1bytes
  public var minute: UInt32 = 0

  ///1bytes
  public var second: UInt32 = 0

  ///1bytes 0~6 星期一~星期日
  public var week: UInt32 = 0

  ///4bytes
  public var utcTime: UInt32 = 0

  ///4bytes 用24时区的，手机端的获取时区是整数，0-12东，13-24西 单位分钟，例如东八区：8*60
  public var timeZone: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_device_time_operate: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  public var time: protocol_time {
    get {return _time ?? protocol_time()}
    set {_time = newValue}
  }
  /// Returns true if `time` has been explicitly set.
  public var hasTime: Bool {return self._time != nil}
  /// Clears the value of `time`. Subsequent reads from it will return its default value.
  public mutating func clearTime() {self._time = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _time: protocol_time? = nil
}

public struct protocol_device_time_inquire_reply: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  public var time: protocol_time {
    get {return _time ?? protocol_time()}
    set {_time = newValue}
  }
  /// Returns true if `time` has been explicitly set.
  public var hasTime: Bool {return self._time != nil}
  /// Clears the value of `time`. Subsequent reads from it will return its default value.
  public mutating func clearTime() {self._time = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _time: protocol_time? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_time: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_time"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "year"),
    2: .same(proto: "month"),
    3: .same(proto: "day"),
    4: .same(proto: "hour"),
    5: .same(proto: "minute"),
    6: .same(proto: "second"),
    7: .same(proto: "week"),
    8: .standard(proto: "utc_time"),
    9: .standard(proto: "time_zone"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.year) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.month) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.day) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.hour) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.minute) }()
      case 6: try { try decoder.decodeSingularUInt32Field(value: &self.second) }()
      case 7: try { try decoder.decodeSingularUInt32Field(value: &self.week) }()
      case 8: try { try decoder.decodeSingularUInt32Field(value: &self.utcTime) }()
      case 9: try { try decoder.decodeSingularUInt32Field(value: &self.timeZone) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.year != 0 {
      try visitor.visitSingularUInt32Field(value: self.year, fieldNumber: 1)
    }
    if self.month != 0 {
      try visitor.visitSingularUInt32Field(value: self.month, fieldNumber: 2)
    }
    if self.day != 0 {
      try visitor.visitSingularUInt32Field(value: self.day, fieldNumber: 3)
    }
    if self.hour != 0 {
      try visitor.visitSingularUInt32Field(value: self.hour, fieldNumber: 4)
    }
    if self.minute != 0 {
      try visitor.visitSingularUInt32Field(value: self.minute, fieldNumber: 5)
    }
    if self.second != 0 {
      try visitor.visitSingularUInt32Field(value: self.second, fieldNumber: 6)
    }
    if self.week != 0 {
      try visitor.visitSingularUInt32Field(value: self.week, fieldNumber: 7)
    }
    if self.utcTime != 0 {
      try visitor.visitSingularUInt32Field(value: self.utcTime, fieldNumber: 8)
    }
    if self.timeZone != 0 {
      try visitor.visitSingularUInt32Field(value: self.timeZone, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_time, rhs: protocol_time) -> Bool {
    if lhs.year != rhs.year {return false}
    if lhs.month != rhs.month {return false}
    if lhs.day != rhs.day {return false}
    if lhs.hour != rhs.hour {return false}
    if lhs.minute != rhs.minute {return false}
    if lhs.second != rhs.second {return false}
    if lhs.week != rhs.week {return false}
    if lhs.utcTime != rhs.utcTime {return false}
    if lhs.timeZone != rhs.timeZone {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_device_time_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_device_time_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .same(proto: "time"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._time) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    try { if let v = self._time {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_device_time_operate, rhs: protocol_device_time_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs._time != rhs._time {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_device_time_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_device_time_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .same(proto: "time"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._time) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    try { if let v = self._time {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_device_time_inquire_reply, rhs: protocol_device_time_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs._time != rhs._time {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
