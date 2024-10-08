// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: disturb.proto
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

///Set the subitem data of the Do Not Disturb timing data
public struct protocol_set_disturb_item {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes do not disturb timer id starts from 0
  public var disturbID: UInt32 = 0

  ///1bytes start time
  public var startHour: UInt32 = 0

  ///1bytes
  public var startMinute: UInt32 = 0

  ///1bytes end time
  public var endHour: UInt32 = 0

  ///1bytes
  public var endMinute: UInt32 = 0

  ///7bytes repeated Monday~Sunday
  public var `repeat`: [Bool] = []

  ///1bytes switch
  public var switchFlag: Bool = false

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_disturb_operate {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes operation type 0: invalid operation 1: query 2: set
  public var operate: operate_type = .invalid

  ///1bytes number of do not disturb
  public var num: UInt32 = 0

  ///1byte Do Not Disturb switch true on, false off
  public var disturbOnOff: Bool = false

  ///max: 5
  public var disturbItem: [protocol_set_disturb_item] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_disturb_inquire_reply {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes function table
  public var funcTable: UInt32 = 0

  ///1bytes maximum number supported by Do Not Disturb
  public var disturbMax: UInt32 = 0

  ///1bytes operation type 0: invalid operation 1: query 2: set
  public var operate: operate_type = .invalid

  ///1bytes number of do not disturb timers
  public var num: UInt32 = 0

  ///1byte Do Not Disturb status switch true on, false off
  public var disturbOnOff: Bool = false

  ///max: 5
  public var disturbItem: [protocol_set_disturb_item] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension protocol_set_disturb_item: @unchecked Sendable {}
extension protocol_disturb_operate: @unchecked Sendable {}
extension protocol_disturb_inquire_reply: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_set_disturb_item: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_set_disturb_item"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "disturb_id"),
    2: .standard(proto: "start_hour"),
    3: .standard(proto: "start_minute"),
    4: .standard(proto: "end_hour"),
    5: .standard(proto: "end_minute"),
    6: .same(proto: "repeat"),
    7: .standard(proto: "switch_flag"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.disturbID) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.startHour) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.startMinute) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.endHour) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.endMinute) }()
      case 6: try { try decoder.decodeRepeatedBoolField(value: &self.`repeat`) }()
      case 7: try { try decoder.decodeSingularBoolField(value: &self.switchFlag) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.disturbID != 0 {
      try visitor.visitSingularUInt32Field(value: self.disturbID, fieldNumber: 1)
    }
    if self.startHour != 0 {
      try visitor.visitSingularUInt32Field(value: self.startHour, fieldNumber: 2)
    }
    if self.startMinute != 0 {
      try visitor.visitSingularUInt32Field(value: self.startMinute, fieldNumber: 3)
    }
    if self.endHour != 0 {
      try visitor.visitSingularUInt32Field(value: self.endHour, fieldNumber: 4)
    }
    if self.endMinute != 0 {
      try visitor.visitSingularUInt32Field(value: self.endMinute, fieldNumber: 5)
    }
    if !self.`repeat`.isEmpty {
      try visitor.visitPackedBoolField(value: self.`repeat`, fieldNumber: 6)
    }
    if self.switchFlag != false {
      try visitor.visitSingularBoolField(value: self.switchFlag, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_set_disturb_item, rhs: protocol_set_disturb_item) -> Bool {
    if lhs.disturbID != rhs.disturbID {return false}
    if lhs.startHour != rhs.startHour {return false}
    if lhs.startMinute != rhs.startMinute {return false}
    if lhs.endHour != rhs.endHour {return false}
    if lhs.endMinute != rhs.endMinute {return false}
    if lhs.`repeat` != rhs.`repeat` {return false}
    if lhs.switchFlag != rhs.switchFlag {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_disturb_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_disturb_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .same(proto: "num"),
    3: .standard(proto: "disturb_on_off"),
    4: .standard(proto: "disturb_item"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.num) }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.disturbOnOff) }()
      case 4: try { try decoder.decodeRepeatedMessageField(value: &self.disturbItem) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.num != 0 {
      try visitor.visitSingularUInt32Field(value: self.num, fieldNumber: 2)
    }
    if self.disturbOnOff != false {
      try visitor.visitSingularBoolField(value: self.disturbOnOff, fieldNumber: 3)
    }
    if !self.disturbItem.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.disturbItem, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_disturb_operate, rhs: protocol_disturb_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.num != rhs.num {return false}
    if lhs.disturbOnOff != rhs.disturbOnOff {return false}
    if lhs.disturbItem != rhs.disturbItem {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_disturb_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_disturb_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "func_table"),
    2: .standard(proto: "disturb_max"),
    3: .same(proto: "operate"),
    4: .same(proto: "num"),
    5: .standard(proto: "disturb_on_off"),
    6: .standard(proto: "disturb_item"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.funcTable) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.disturbMax) }()
      case 3: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.num) }()
      case 5: try { try decoder.decodeSingularBoolField(value: &self.disturbOnOff) }()
      case 6: try { try decoder.decodeRepeatedMessageField(value: &self.disturbItem) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.funcTable != 0 {
      try visitor.visitSingularUInt32Field(value: self.funcTable, fieldNumber: 1)
    }
    if self.disturbMax != 0 {
      try visitor.visitSingularUInt32Field(value: self.disturbMax, fieldNumber: 2)
    }
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 3)
    }
    if self.num != 0 {
      try visitor.visitSingularUInt32Field(value: self.num, fieldNumber: 4)
    }
    if self.disturbOnOff != false {
      try visitor.visitSingularBoolField(value: self.disturbOnOff, fieldNumber: 5)
    }
    if !self.disturbItem.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.disturbItem, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_disturb_inquire_reply, rhs: protocol_disturb_inquire_reply) -> Bool {
    if lhs.funcTable != rhs.funcTable {return false}
    if lhs.disturbMax != rhs.disturbMax {return false}
    if lhs.operate != rhs.operate {return false}
    if lhs.num != rhs.num {return false}
    if lhs.disturbOnOff != rhs.disturbOnOff {return false}
    if lhs.disturbItem != rhs.disturbItem {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
