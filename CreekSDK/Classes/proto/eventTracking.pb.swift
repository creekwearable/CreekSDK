// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: eventTracking.proto
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

public struct sport_bt_conn {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///Sports time
  public var sportDurations: UInt32 = 0

  ///Connect Bluetooth time
  public var btDurations: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_event_tracking_operate {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes operation type 0: invalid operation 1: query 2: setting
  public var operate: operate_type = .invalid

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_event_tracking_inquire_reply {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes operation type 0: invalid operation 1: query 2: setting
  public var operate: operate_type = .invalid

  ///Record the duration of the call function
  public var phoneFunc: [UInt32] = []

  ///Record the start time point of click dialing
  public var clickDial: [UInt32] = []

  ///Record the start time point of click to answer
  public var clickAnswer: [UInt32] = []

  ///Record the duration of Bluetooth connection during exercise
  public var sportBtConn: [sport_bt_conn] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension sport_bt_conn: @unchecked Sendable {}
extension protocol_event_tracking_operate: @unchecked Sendable {}
extension protocol_event_tracking_inquire_reply: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension sport_bt_conn: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "sport_bt_conn"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "sport_durations"),
    2: .standard(proto: "bt_durations"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.sportDurations) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.btDurations) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sportDurations != 0 {
      try visitor.visitSingularUInt32Field(value: self.sportDurations, fieldNumber: 1)
    }
    if self.btDurations != 0 {
      try visitor.visitSingularUInt32Field(value: self.btDurations, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: sport_bt_conn, rhs: sport_bt_conn) -> Bool {
    if lhs.sportDurations != rhs.sportDurations {return false}
    if lhs.btDurations != rhs.btDurations {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_event_tracking_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_event_tracking_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_event_tracking_operate, rhs: protocol_event_tracking_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_event_tracking_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_event_tracking_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "phone_func"),
    3: .standard(proto: "click_dial"),
    4: .standard(proto: "click_answer"),
    5: .standard(proto: "sport_bt_conn"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeRepeatedUInt32Field(value: &self.phoneFunc) }()
      case 3: try { try decoder.decodeRepeatedUInt32Field(value: &self.clickDial) }()
      case 4: try { try decoder.decodeRepeatedUInt32Field(value: &self.clickAnswer) }()
      case 5: try { try decoder.decodeRepeatedMessageField(value: &self.sportBtConn) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if !self.phoneFunc.isEmpty {
      try visitor.visitPackedUInt32Field(value: self.phoneFunc, fieldNumber: 2)
    }
    if !self.clickDial.isEmpty {
      try visitor.visitPackedUInt32Field(value: self.clickDial, fieldNumber: 3)
    }
    if !self.clickAnswer.isEmpty {
      try visitor.visitPackedUInt32Field(value: self.clickAnswer, fieldNumber: 4)
    }
    if !self.sportBtConn.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.sportBtConn, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_event_tracking_inquire_reply, rhs: protocol_event_tracking_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.phoneFunc != rhs.phoneFunc {return false}
    if lhs.clickDial != rhs.clickDial {return false}
    if lhs.clickAnswer != rhs.clickAnswer {return false}
    if lhs.sportBtConn != rhs.sportBtConn {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}