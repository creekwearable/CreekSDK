// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: menstrual.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
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

public struct protocol_menstrual_period_set {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes female health switch true on, false off
  public var switchFlag: Bool = false

  ///1bytes period length
  public var periodLength: UInt32 = 0

  ///1bytes menstrual cycle
  public var cycleLength: UInt32 = 0

  ///2bytes last menstrual period start time
  public var lastYear: UInt32 = 0

  public var lastMonth: UInt32 = 0

  public var lastDay: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_menstrual_record {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///2bytes date
  public var year: UInt32 = 0

  public var month: UInt32 = 0

  public var day: UInt32 = 0

  public var log: period_log = .null

  ///Operation time, utc time, such as the operation record period, this time point is used as the operation time
  public var operateUtcTime: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_menstruation_operate {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes operation type 0: invalid operation 1: query 2: set
  public var operate: operate_type = .invalid

  ///menstrual period setting
  public var periodSet: protocol_menstrual_period_set {
    get {return _periodSet ?? protocol_menstrual_period_set()}
    set {_periodSet = newValue}
  }
  /// Returns true if `periodSet` has been explicitly set.
  public var hasPeriodSet: Bool {return self._periodSet != nil}
  /// Clears the value of `periodSet`. Subsequent reads from it will return its default value.
  public mutating func clearPeriodSet() {self._periodSet = nil}

  ///Record operation time
  public var record: [protocol_menstrual_record] = []

  ///Set the recorded utc time, record time
  public var setUtcTime: UInt32 = 0

  ///1bytes menstrual cycle reminder (ovulation reminder, predicted menstrual period reminder) switch
  public var reminderSwitch: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _periodSet: protocol_menstrual_period_set? = nil
}

public struct protocol_menstruation_inquire_reply {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes function table
  public var funcTable: UInt32 = 0

  ///1bytes operation type 0: invalid operation 1: query 2: set
  public var operate: operate_type = .invalid

  ///menstrual period setting
  public var menstrualPeriodSet: protocol_menstrual_period_set {
    get {return _menstrualPeriodSet ?? protocol_menstrual_period_set()}
    set {_menstrualPeriodSet = newValue}
  }
  /// Returns true if `menstrualPeriodSet` has been explicitly set.
  public var hasMenstrualPeriodSet: Bool {return self._menstrualPeriodSet != nil}
  /// Clears the value of `menstrualPeriodSet`. Subsequent reads from it will return its default value.
  public mutating func clearMenstrualPeriodSet() {self._menstrualPeriodSet = nil}

  ///Record operation time
  public var record: [protocol_menstrual_record] = []

  ///Set the recorded utc time, record time
  public var setUtcTime: UInt32 = 0

  ///1bytes menstrual cycle reminder (ovulation reminder, predicted menstrual period reminder) switch
  public var reminderSwitch: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _menstrualPeriodSet: protocol_menstrual_period_set? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension protocol_menstrual_period_set: @unchecked Sendable {}
extension protocol_menstrual_record: @unchecked Sendable {}
extension protocol_menstruation_operate: @unchecked Sendable {}
extension protocol_menstruation_inquire_reply: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_menstrual_period_set: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_menstrual_period_set"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "switch_flag"),
    2: .standard(proto: "period_length"),
    3: .standard(proto: "cycle_length"),
    4: .standard(proto: "last_year"),
    5: .standard(proto: "last_month"),
    6: .standard(proto: "last_day"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBoolField(value: &self.switchFlag) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.periodLength) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.cycleLength) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.lastYear) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.lastMonth) }()
      case 6: try { try decoder.decodeSingularUInt32Field(value: &self.lastDay) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.switchFlag != false {
      try visitor.visitSingularBoolField(value: self.switchFlag, fieldNumber: 1)
    }
    if self.periodLength != 0 {
      try visitor.visitSingularUInt32Field(value: self.periodLength, fieldNumber: 2)
    }
    if self.cycleLength != 0 {
      try visitor.visitSingularUInt32Field(value: self.cycleLength, fieldNumber: 3)
    }
    if self.lastYear != 0 {
      try visitor.visitSingularUInt32Field(value: self.lastYear, fieldNumber: 4)
    }
    if self.lastMonth != 0 {
      try visitor.visitSingularUInt32Field(value: self.lastMonth, fieldNumber: 5)
    }
    if self.lastDay != 0 {
      try visitor.visitSingularUInt32Field(value: self.lastDay, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_menstrual_period_set, rhs: protocol_menstrual_period_set) -> Bool {
    if lhs.switchFlag != rhs.switchFlag {return false}
    if lhs.periodLength != rhs.periodLength {return false}
    if lhs.cycleLength != rhs.cycleLength {return false}
    if lhs.lastYear != rhs.lastYear {return false}
    if lhs.lastMonth != rhs.lastMonth {return false}
    if lhs.lastDay != rhs.lastDay {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_menstrual_record: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_menstrual_record"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "year"),
    2: .same(proto: "month"),
    3: .same(proto: "day"),
    4: .same(proto: "log"),
    5: .standard(proto: "operate_utc_time"),
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
      case 4: try { try decoder.decodeSingularEnumField(value: &self.log) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.operateUtcTime) }()
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
    if self.log != .null {
      try visitor.visitSingularEnumField(value: self.log, fieldNumber: 4)
    }
    if self.operateUtcTime != 0 {
      try visitor.visitSingularUInt32Field(value: self.operateUtcTime, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_menstrual_record, rhs: protocol_menstrual_record) -> Bool {
    if lhs.year != rhs.year {return false}
    if lhs.month != rhs.month {return false}
    if lhs.day != rhs.day {return false}
    if lhs.log != rhs.log {return false}
    if lhs.operateUtcTime != rhs.operateUtcTime {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_menstruation_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_menstruation_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "period_set"),
    3: .same(proto: "record"),
    4: .standard(proto: "set_utc_time"),
    5: .standard(proto: "reminder_switch"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._periodSet) }()
      case 3: try { try decoder.decodeRepeatedMessageField(value: &self.record) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.setUtcTime) }()
      case 5: try { try decoder.decodeSingularBoolField(value: &self.reminderSwitch) }()
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
    try { if let v = self._periodSet {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    if !self.record.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.record, fieldNumber: 3)
    }
    if self.setUtcTime != 0 {
      try visitor.visitSingularUInt32Field(value: self.setUtcTime, fieldNumber: 4)
    }
    if self.reminderSwitch != false {
      try visitor.visitSingularBoolField(value: self.reminderSwitch, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_menstruation_operate, rhs: protocol_menstruation_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs._periodSet != rhs._periodSet {return false}
    if lhs.record != rhs.record {return false}
    if lhs.setUtcTime != rhs.setUtcTime {return false}
    if lhs.reminderSwitch != rhs.reminderSwitch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_menstruation_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_menstruation_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "func_table"),
    2: .same(proto: "operate"),
    3: .standard(proto: "menstrual_period_set"),
    4: .same(proto: "record"),
    5: .standard(proto: "set_utc_time"),
    6: .standard(proto: "reminder_switch"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.funcTable) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 3: try { try decoder.decodeSingularMessageField(value: &self._menstrualPeriodSet) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.record) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.setUtcTime) }()
      case 6: try { try decoder.decodeSingularBoolField(value: &self.reminderSwitch) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.funcTable != 0 {
      try visitor.visitSingularUInt32Field(value: self.funcTable, fieldNumber: 1)
    }
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 2)
    }
    try { if let v = self._menstrualPeriodSet {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
    } }()
    if !self.record.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.record, fieldNumber: 4)
    }
    if self.setUtcTime != 0 {
      try visitor.visitSingularUInt32Field(value: self.setUtcTime, fieldNumber: 5)
    }
    if self.reminderSwitch != false {
      try visitor.visitSingularBoolField(value: self.reminderSwitch, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_menstruation_inquire_reply, rhs: protocol_menstruation_inquire_reply) -> Bool {
    if lhs.funcTable != rhs.funcTable {return false}
    if lhs.operate != rhs.operate {return false}
    if lhs._menstrualPeriodSet != rhs._menstrualPeriodSet {return false}
    if lhs.record != rhs.record {return false}
    if lhs.setUtcTime != rhs.setUtcTime {return false}
    if lhs.reminderSwitch != rhs.reminderSwitch {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
