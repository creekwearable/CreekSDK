//
//  CreekRingtoneModel.swift
//  CreekSDK
//

import Foundation

/// Metadata prepended to a ringtone during upload.
public final class CreekRingtoneModel: Codable {
   public let ringtoneId: UInt32
   public let ringtoneName: String
   public let durationSeconds: Int?

   public init(ringtoneId: UInt32, ringtoneName: String, durationSeconds: Int? = nil) {
      self.ringtoneId = ringtoneId
      self.ringtoneName = ringtoneName
      self.durationSeconds = durationSeconds
   }
}
