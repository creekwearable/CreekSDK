import Foundation
import XCTest
@testable import PrayerContract

final class PrayerModelsTests: XCTestCase {
   func testInputContractMatchesDartNames() throws {
      let config = CreekPrayerConfiguration(automatic: false, method: .northAmerica, asrRule: .hanafi)
      let json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(config)) as! [String: Any]
      XCTAssertEqual(json["method"] as? String, "northAmerica")
      XCTAssertEqual(json["automatic"] as? Bool, false)
      XCTAssertEqual(json["asrRule"] as? String, "hanafi")
      XCTAssertNil(json["location"])
      XCTAssertEqual(PrayerCalculationMethod.allCases.count, 16)
      let location = PrayerLocation.coordinates(latitude: 33.58831, longitude: -7.61138, countryCode: "MA", name: "Casablanca")
      let coordinates = try JSONSerialization.jsonObject(with: JSONEncoder().encode(location)) as! [String: Any]
      XCTAssertEqual(coordinates["selection"] as? String, "coordinates")
      XCTAssertEqual(coordinates["latitude"] as? Double, 33.58831)
      XCTAssertNil(coordinates["timezoneId"])
   }

   func testActualDartResultDecodesAndWatchPayloadMatchesDisplayedTimes() throws {
      let url = Bundle.module.url(forResource: "prayer_result", withExtension: "json", subdirectory: "Fixtures")!
      let result = try JSONDecoder().decode(CreekPrayerResult.self, from: Data(contentsOf: url))
      XCTAssertEqual(result.days.count, 7)
      XCTAssertEqual(result.days.first?.date, "2026-11-16")
      XCTAssertEqual(result.configuration.location.timezoneId, "Africa/Casablanca")
      XCTAssertEqual(result.configuration.method, .morocco)
      XCTAssertEqual(result.operate.prayer.data.count, 7)
      XCTAssertEqual(result.operate.prayer.data.first?.date, 14480606)
      for (day, payload) in zip(result.days, result.operate.prayer.data) {
         let actual = [payload.fajrTime, payload.sunriseTime, payload.dhuhrTime, payload.asrTime, payload.maghribTime, payload.ishaTime]
            .map { String(format: "%02d:%02d", $0.hour, $0.minute) }
         XCTAssertEqual(actual, [day.fajr, day.sunrise, day.dhuhr, day.asr, day.maghrib, day.isha])
      }
      XCTAssertFalse(try result.operate.serializedData().isEmpty)
   }

   func testBrokenBridgePayloadFailsInsteadOfReturningEmptyWatchData() throws {
      let url = Bundle.module.url(forResource: "prayer_result", withExtension: "json", subdirectory: "Fixtures")!
      var json = try JSONSerialization.jsonObject(with: Data(contentsOf: url)) as! [String: Any]
      json["operate"] = "not valid base64!"
      XCTAssertThrowsError(try JSONDecoder().decode(CreekPrayerResult.self, from: JSONSerialization.data(withJSONObject: json)))
   }
}
