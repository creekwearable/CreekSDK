import Foundation
import SwiftProtobuf

public enum PrayerCalculationMethod: String, Codable, CaseIterable {
   case morocco, karachi, northAmerica, muslimWorldLeague, egyptian, ummAlQura
   case france, algerian, tunisia, kuwait, paris, uae, palestine, turkiye, belgium, igmg
}

public enum PrayerAsrRule: String, Codable, CaseIterable { case standard, hanafi }
public enum PrayerTimeSource: String, Codable { case localCalculation, suppliedTimetable, onlineTimetable }

/// User preferences, persisted by the SDK. Location is supplied only when reading.
public struct CreekPrayerConfiguration: Codable {
   public var automatic: Bool
   public var method: PrayerCalculationMethod
   public var asrRule: PrayerAsrRule
   public init(automatic: Bool = true, method: PrayerCalculationMethod = .morocco,
               asrRule: PrayerAsrRule = .standard) {
      self.automatic = automatic
      self.method = method
      self.asrRule = asrRule
   }
}

/// Input location. Timezone and online/local selection are internal SDK decisions.
public struct PrayerLocation: Encodable {
   private let selection: String
   public let latitude: Double?
   public let longitude: Double?
   public let countryCode: String?
   public let name: String
   public let altitude: Double
   private let cityId: Int?

   public static func coordinates(latitude: Double, longitude: Double, countryCode: String,
                                  name: String = "", altitude: Double = 0) -> PrayerLocation {
      PrayerLocation(selection: "coordinates", latitude: latitude, longitude: longitude,
                     countryCode: countryCode, name: name, altitude: altitude, cityId: nil)
   }
   public static func cityName(name: String, countryCode: String) -> PrayerLocation {
      PrayerLocation(selection: "cityName", latitude: nil, longitude: nil,
                     countryCode: countryCode, name: name, altitude: 0, cityId: nil)
   }
   /// Only accepts an ID from the SDK's embedded city database.
   public static func city(id: Int) -> PrayerLocation {
      PrayerLocation(selection: "city", latitude: nil, longitude: nil,
                     countryCode: nil, name: "", altitude: 0, cityId: id)
   }
}

/// A destination-local calendar date. Omit to read today and the next six days.
public struct PrayerDate: Codable {
   public let year: Int
   public let month: Int
   public let day: Int
   public init(year: Int, month: Int, day: Int) {
      self.year = year; self.month = month; self.day = day
   }
}

public struct PrayerResolvedLocation: Decodable {
   public let name: String
   public let countryCode: String
   public let latitude: Double
   public let longitude: Double
   public let altitude: Double
   public let timezoneId: String
}

public struct PrayerResolvedConfiguration: Decodable {
   public let automatic: Bool
   public let method: PrayerCalculationMethod
   public let asrRule: PrayerAsrRule
   public let location: PrayerResolvedLocation
}

/// All time strings are destination-local HH:mm, not UTC or phone-local time.
public struct PrayerDay: Decodable {
   public let date: String // Gregorian YYYY-MM-DD
   public let timezoneId: String
   public let utcOffsetMinutes: Int
   public let method: PrayerCalculationMethod
   public let asrRule: PrayerAsrRule
   public let source: PrayerTimeSource
   public let fajr: String
   public let sunrise: String
   public let dhuhr: String
   public let asr: String
   public let maghrib: String
   public let isha: String
   public let extreme: [Bool]
   public let diagnostics: [String]
}

public struct CreekPrayerResult: Decodable {
   public let configuration: PrayerResolvedConfiguration
   public let days: [PrayerDay]
   /// Ready for setPrayer(model:). Dates are already encoded for the watch.
   public let operate: protocol_prayer_operate
   private enum CodingKeys: String, CodingKey { case configuration, days, operate }
   public init(from decoder: Swift.Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      configuration = try values.decode(PrayerResolvedConfiguration.self, forKey: .configuration)
      days = try values.decode([PrayerDay].self, forKey: .days)
      let bytes = try values.decode(Data.self, forKey: .operate)
      operate = try protocol_prayer_operate(serializedData: bytes)
   }
}
