// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: healthsnapshot.proto
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

public struct protocol_health_snap_item: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var year: UInt32 = 0

  public var month: UInt32 = 0

  public var day: UInt32 = 0

  public var hour: UInt32 = 0

  public var minute: UInt32 = 0

  public var second: UInt32 = 0

  public var hrValue: UInt32 = 0

  public var spo2Value: UInt32 = 0

  public var hrvValue: UInt32 = 0

  ///respiratory rate
  public var rrValue: UInt32 = 0

  public var stressValue: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_health_snap_operate: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型
  public var operate: operate_health_snap_type = .snapInvalid

  ///当前多少页，用于分段传输。
  public var pageIndex: UInt32 = 0

  ///当前页传输多少条数据，用于分段传输。
  public var pageNum: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_health_snap_inquire_reply: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes操作类型
  public var operate: operate_health_snap_type = .snapInvalid

  ///1bytes 功能表
  public var funcTable: UInt32 = 0

  ///1bytes 健康快照记录最大数量
  public var snapRecordSupportMax: UInt32 = 0

  ///当前多少页，用于分段传输。
  public var pageIndex: UInt32 = 0

  ///当前页传输多少条数据，用于分段传输。
  public var pageNum: UInt32 = 0

  public var snapItems: [protocol_health_snap_item] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_health_snap_item: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_health_snap_item"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "year"),
    2: .same(proto: "month"),
    3: .same(proto: "day"),
    4: .same(proto: "hour"),
    5: .same(proto: "minute"),
    6: .same(proto: "second"),
    7: .standard(proto: "hr_value"),
    8: .standard(proto: "spo2_value"),
    9: .standard(proto: "hrv_value"),
    10: .standard(proto: "rr_value"),
    11: .standard(proto: "stress_value"),
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
      case 7: try { try decoder.decodeSingularUInt32Field(value: &self.hrValue) }()
      case 8: try { try decoder.decodeSingularUInt32Field(value: &self.spo2Value) }()
      case 9: try { try decoder.decodeSingularUInt32Field(value: &self.hrvValue) }()
      case 10: try { try decoder.decodeSingularUInt32Field(value: &self.rrValue) }()
      case 11: try { try decoder.decodeSingularUInt32Field(value: &self.stressValue) }()
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
    if self.hrValue != 0 {
      try visitor.visitSingularUInt32Field(value: self.hrValue, fieldNumber: 7)
    }
    if self.spo2Value != 0 {
      try visitor.visitSingularUInt32Field(value: self.spo2Value, fieldNumber: 8)
    }
    if self.hrvValue != 0 {
      try visitor.visitSingularUInt32Field(value: self.hrvValue, fieldNumber: 9)
    }
    if self.rrValue != 0 {
      try visitor.visitSingularUInt32Field(value: self.rrValue, fieldNumber: 10)
    }
    if self.stressValue != 0 {
      try visitor.visitSingularUInt32Field(value: self.stressValue, fieldNumber: 11)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_health_snap_item, rhs: protocol_health_snap_item) -> Bool {
    if lhs.year != rhs.year {return false}
    if lhs.month != rhs.month {return false}
    if lhs.day != rhs.day {return false}
    if lhs.hour != rhs.hour {return false}
    if lhs.minute != rhs.minute {return false}
    if lhs.second != rhs.second {return false}
    if lhs.hrValue != rhs.hrValue {return false}
    if lhs.spo2Value != rhs.spo2Value {return false}
    if lhs.hrvValue != rhs.hrvValue {return false}
    if lhs.rrValue != rhs.rrValue {return false}
    if lhs.stressValue != rhs.stressValue {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_health_snap_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_health_snap_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "page_index"),
    3: .standard(proto: "page_num"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.pageIndex) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.pageNum) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .snapInvalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.pageIndex != 0 {
      try visitor.visitSingularUInt32Field(value: self.pageIndex, fieldNumber: 2)
    }
    if self.pageNum != 0 {
      try visitor.visitSingularUInt32Field(value: self.pageNum, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_health_snap_operate, rhs: protocol_health_snap_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.pageIndex != rhs.pageIndex {return false}
    if lhs.pageNum != rhs.pageNum {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_health_snap_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_health_snap_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "func_table"),
    3: .standard(proto: "snap_record_support_max"),
    4: .standard(proto: "page_index"),
    5: .standard(proto: "page_num"),
    6: .standard(proto: "snap_items"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.funcTable) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.snapRecordSupportMax) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.pageIndex) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.pageNum) }()
      case 6: try { try decoder.decodeRepeatedMessageField(value: &self.snapItems) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .snapInvalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.funcTable != 0 {
      try visitor.visitSingularUInt32Field(value: self.funcTable, fieldNumber: 2)
    }
    if self.snapRecordSupportMax != 0 {
      try visitor.visitSingularUInt32Field(value: self.snapRecordSupportMax, fieldNumber: 3)
    }
    if self.pageIndex != 0 {
      try visitor.visitSingularUInt32Field(value: self.pageIndex, fieldNumber: 4)
    }
    if self.pageNum != 0 {
      try visitor.visitSingularUInt32Field(value: self.pageNum, fieldNumber: 5)
    }
    if !self.snapItems.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.snapItems, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_health_snap_inquire_reply, rhs: protocol_health_snap_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.funcTable != rhs.funcTable {return false}
    if lhs.snapRecordSupportMax != rhs.snapRecordSupportMax {return false}
    if lhs.pageIndex != rhs.pageIndex {return false}
    if lhs.pageNum != rhs.pageNum {return false}
    if lhs.snapItems != rhs.snapItems {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
