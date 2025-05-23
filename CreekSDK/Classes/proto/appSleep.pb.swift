// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: appSleep.proto
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

public struct protocol_psp_sleep_data_time: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var year: UInt32 = 0

  public var month: UInt32 = 0

  public var day: UInt32 = 0

  public var hour: UInt32 = 0

  public var minute: UInt32 = 0

  public var second: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_data: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///入睡时间
  public var fallAsleepTime: protocol_psp_sleep_data_time {
    get {return _storage._fallAsleepTime ?? protocol_psp_sleep_data_time()}
    set {_uniqueStorage()._fallAsleepTime = newValue}
  }
  /// Returns true if `fallAsleepTime` has been explicitly set.
  public var hasFallAsleepTime: Bool {return _storage._fallAsleepTime != nil}
  /// Clears the value of `fallAsleepTime`. Subsequent reads from it will return its default value.
  public mutating func clearFallAsleepTime() {_uniqueStorage()._fallAsleepTime = nil}

  ///起床时间
  public var getUpTime: protocol_psp_sleep_data_time {
    get {return _storage._getUpTime ?? protocol_psp_sleep_data_time()}
    set {_uniqueStorage()._getUpTime = newValue}
  }
  /// Returns true if `getUpTime` has been explicitly set.
  public var hasGetUpTime: Bool {return _storage._getUpTime != nil}
  /// Clears the value of `getUpTime`. Subsequent reads from it will return its default value.
  public mutating func clearGetUpTime() {_uniqueStorage()._getUpTime = nil}

  ///睡眠总时长
  public var totalSleepTimeMins: UInt32 {
    get {return _storage._totalSleepTimeMins}
    set {_uniqueStorage()._totalSleepTimeMins = newValue}
  }

  ///睡眠阶段-总清醒时长, 单位:分钟
  public var wakeMins: UInt32 {
    get {return _storage._wakeMins}
    set {_uniqueStorage()._wakeMins = newValue}
  }

  ///睡眠阶段-总浅眠时长 单位:分钟
  public var lightSleepMins: UInt32 {
    get {return _storage._lightSleepMins}
    set {_uniqueStorage()._lightSleepMins = newValue}
  }

  ///睡眠阶段-总深眠时长 单位:分钟
  public var deepSleepMins: UInt32 {
    get {return _storage._deepSleepMins}
    set {_uniqueStorage()._deepSleepMins = newValue}
  }

  ///睡眠阶段-总REM时长 单位:分钟
  public var remMins: UInt32 {
    get {return _storage._remMins}
    set {_uniqueStorage()._remMins = newValue}
  }

  ///睡眠得分
  public var sleepScore: UInt32 {
    get {return _storage._sleepScore}
    set {_uniqueStorage()._sleepScore = newValue}
  }

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

public struct protocol_psp_sleep_data_operate: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///睡眠数据
  public var sleepData: [protocol_psp_sleep_data] = []

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_data_inquire_reply: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  ///最大支持多少条睡眠数据
  public var sleepDataSupportMax: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_score_data: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var sleepID: UInt32 = 0

  ///睡眠总时长
  public var totalSleepTimeMins: UInt32 = 0

  ///睡眠阶段-总清醒时长, 单位:分钟
  public var wakeMins: UInt32 = 0

  ///睡眠阶段-总浅眠时长 单位:分钟
  public var lightSleepMins: UInt32 = 0

  ///睡眠阶段-总深眠时长 单位:分钟
  public var deepSleepMins: UInt32 = 0

  ///睡眠阶段-总REM时长 单位:分钟
  public var remMins: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_score_result: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var sleepID: UInt32 = 0

  ///睡眠得分
  public var sleepScore: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_score_operate: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  ///睡眠数据 根据睡眠数据查询睡眠得分
  public var sleepData: [protocol_psp_sleep_score_data] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct protocol_psp_sleep_score_inquire_reply: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  ///1bytes 操作类型 0：无效操作 1：查询 2：设置
  public var operate: operate_type = .invalid

  ///睡眠得分
  public var sleepScore: [protocol_psp_sleep_score_result] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension protocol_psp_sleep_data_time: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_data_time"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "year"),
    2: .same(proto: "month"),
    3: .same(proto: "day"),
    4: .same(proto: "hour"),
    5: .same(proto: "minute"),
    6: .same(proto: "second"),
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
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_data_time, rhs: protocol_psp_sleep_data_time) -> Bool {
    if lhs.year != rhs.year {return false}
    if lhs.month != rhs.month {return false}
    if lhs.day != rhs.day {return false}
    if lhs.hour != rhs.hour {return false}
    if lhs.minute != rhs.minute {return false}
    if lhs.second != rhs.second {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_data: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_data"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "fall_asleep_time"),
    2: .standard(proto: "get_up_time"),
    3: .standard(proto: "total_sleep_time_mins"),
    4: .standard(proto: "wake_mins"),
    5: .standard(proto: "light_sleep_mins"),
    6: .standard(proto: "deep_sleep_mins"),
    7: .standard(proto: "rem_mins"),
    8: .standard(proto: "sleep_score"),
  ]

  fileprivate class _StorageClass {
    var _fallAsleepTime: protocol_psp_sleep_data_time? = nil
    var _getUpTime: protocol_psp_sleep_data_time? = nil
    var _totalSleepTimeMins: UInt32 = 0
    var _wakeMins: UInt32 = 0
    var _lightSleepMins: UInt32 = 0
    var _deepSleepMins: UInt32 = 0
    var _remMins: UInt32 = 0
    var _sleepScore: UInt32 = 0

    #if swift(>=5.10)
      // This property is used as the initial default value for new instances of the type.
      // The type itself is protecting the reference to its storage via CoW semantics.
      // This will force a copy to be made of this reference when the first mutation occurs;
      // hence, it is safe to mark this as `nonisolated(unsafe)`.
      static nonisolated(unsafe) let defaultInstance = _StorageClass()
    #else
      static let defaultInstance = _StorageClass()
    #endif

    private init() {}

    init(copying source: _StorageClass) {
      _fallAsleepTime = source._fallAsleepTime
      _getUpTime = source._getUpTime
      _totalSleepTimeMins = source._totalSleepTimeMins
      _wakeMins = source._wakeMins
      _lightSleepMins = source._lightSleepMins
      _deepSleepMins = source._deepSleepMins
      _remMins = source._remMins
      _sleepScore = source._sleepScore
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularMessageField(value: &_storage._fallAsleepTime) }()
        case 2: try { try decoder.decodeSingularMessageField(value: &_storage._getUpTime) }()
        case 3: try { try decoder.decodeSingularUInt32Field(value: &_storage._totalSleepTimeMins) }()
        case 4: try { try decoder.decodeSingularUInt32Field(value: &_storage._wakeMins) }()
        case 5: try { try decoder.decodeSingularUInt32Field(value: &_storage._lightSleepMins) }()
        case 6: try { try decoder.decodeSingularUInt32Field(value: &_storage._deepSleepMins) }()
        case 7: try { try decoder.decodeSingularUInt32Field(value: &_storage._remMins) }()
        case 8: try { try decoder.decodeSingularUInt32Field(value: &_storage._sleepScore) }()
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      try { if let v = _storage._fallAsleepTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      } }()
      try { if let v = _storage._getUpTime {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      } }()
      if _storage._totalSleepTimeMins != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._totalSleepTimeMins, fieldNumber: 3)
      }
      if _storage._wakeMins != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._wakeMins, fieldNumber: 4)
      }
      if _storage._lightSleepMins != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._lightSleepMins, fieldNumber: 5)
      }
      if _storage._deepSleepMins != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._deepSleepMins, fieldNumber: 6)
      }
      if _storage._remMins != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._remMins, fieldNumber: 7)
      }
      if _storage._sleepScore != 0 {
        try visitor.visitSingularUInt32Field(value: _storage._sleepScore, fieldNumber: 8)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_data, rhs: protocol_psp_sleep_data) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._fallAsleepTime != rhs_storage._fallAsleepTime {return false}
        if _storage._getUpTime != rhs_storage._getUpTime {return false}
        if _storage._totalSleepTimeMins != rhs_storage._totalSleepTimeMins {return false}
        if _storage._wakeMins != rhs_storage._wakeMins {return false}
        if _storage._lightSleepMins != rhs_storage._lightSleepMins {return false}
        if _storage._deepSleepMins != rhs_storage._deepSleepMins {return false}
        if _storage._remMins != rhs_storage._remMins {return false}
        if _storage._sleepScore != rhs_storage._sleepScore {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_data_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_data_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "sleep_data"),
    2: .same(proto: "operate"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.sleepData) }()
      case 2: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.sleepData.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.sleepData, fieldNumber: 1)
    }
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_data_operate, rhs: protocol_psp_sleep_data_operate) -> Bool {
    if lhs.sleepData != rhs.sleepData {return false}
    if lhs.operate != rhs.operate {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_data_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_data_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "sleep_data_support_max"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.sleepDataSupportMax) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if self.sleepDataSupportMax != 0 {
      try visitor.visitSingularUInt32Field(value: self.sleepDataSupportMax, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_data_inquire_reply, rhs: protocol_psp_sleep_data_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.sleepDataSupportMax != rhs.sleepDataSupportMax {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_score_data: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_score_data"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "sleep_id"),
    2: .standard(proto: "total_sleep_time_mins"),
    3: .standard(proto: "wake_mins"),
    4: .standard(proto: "light_sleep_mins"),
    5: .standard(proto: "deep_sleep_mins"),
    6: .standard(proto: "rem_mins"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.sleepID) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.totalSleepTimeMins) }()
      case 3: try { try decoder.decodeSingularUInt32Field(value: &self.wakeMins) }()
      case 4: try { try decoder.decodeSingularUInt32Field(value: &self.lightSleepMins) }()
      case 5: try { try decoder.decodeSingularUInt32Field(value: &self.deepSleepMins) }()
      case 6: try { try decoder.decodeSingularUInt32Field(value: &self.remMins) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sleepID != 0 {
      try visitor.visitSingularUInt32Field(value: self.sleepID, fieldNumber: 1)
    }
    if self.totalSleepTimeMins != 0 {
      try visitor.visitSingularUInt32Field(value: self.totalSleepTimeMins, fieldNumber: 2)
    }
    if self.wakeMins != 0 {
      try visitor.visitSingularUInt32Field(value: self.wakeMins, fieldNumber: 3)
    }
    if self.lightSleepMins != 0 {
      try visitor.visitSingularUInt32Field(value: self.lightSleepMins, fieldNumber: 4)
    }
    if self.deepSleepMins != 0 {
      try visitor.visitSingularUInt32Field(value: self.deepSleepMins, fieldNumber: 5)
    }
    if self.remMins != 0 {
      try visitor.visitSingularUInt32Field(value: self.remMins, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_score_data, rhs: protocol_psp_sleep_score_data) -> Bool {
    if lhs.sleepID != rhs.sleepID {return false}
    if lhs.totalSleepTimeMins != rhs.totalSleepTimeMins {return false}
    if lhs.wakeMins != rhs.wakeMins {return false}
    if lhs.lightSleepMins != rhs.lightSleepMins {return false}
    if lhs.deepSleepMins != rhs.deepSleepMins {return false}
    if lhs.remMins != rhs.remMins {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_score_result: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_score_result"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "sleep_id"),
    2: .standard(proto: "sleep_score"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularUInt32Field(value: &self.sleepID) }()
      case 2: try { try decoder.decodeSingularUInt32Field(value: &self.sleepScore) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.sleepID != 0 {
      try visitor.visitSingularUInt32Field(value: self.sleepID, fieldNumber: 1)
    }
    if self.sleepScore != 0 {
      try visitor.visitSingularUInt32Field(value: self.sleepScore, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_score_result, rhs: protocol_psp_sleep_score_result) -> Bool {
    if lhs.sleepID != rhs.sleepID {return false}
    if lhs.sleepScore != rhs.sleepScore {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_score_operate: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_score_operate"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "sleep_data"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.sleepData) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if !self.sleepData.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.sleepData, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_score_operate, rhs: protocol_psp_sleep_score_operate) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.sleepData != rhs.sleepData {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension protocol_psp_sleep_score_inquire_reply: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "protocol_psp_sleep_score_inquire_reply"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "operate"),
    2: .standard(proto: "sleep_score"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.operate) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.sleepScore) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.operate != .invalid {
      try visitor.visitSingularEnumField(value: self.operate, fieldNumber: 1)
    }
    if !self.sleepScore.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.sleepScore, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: protocol_psp_sleep_score_inquire_reply, rhs: protocol_psp_sleep_score_inquire_reply) -> Bool {
    if lhs.operate != rhs.operate {return false}
    if lhs.sleepScore != rhs.sleepScore {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
