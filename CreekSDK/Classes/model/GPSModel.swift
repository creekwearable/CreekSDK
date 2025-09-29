import UIKit

public class GPSModel: Codable, CustomStringConvertible {
    public var latitude: Int?
    public var longitude: Int?
    public var accuracy: Int?
    public var gpsPermission: Bool = true

    // MARK: - Initializer
    public init(latitude: Int? = nil, longitude: Int? = nil, accuracy: Int? = nil, gpsPermission: Bool = true) {
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
        self.gpsPermission = gpsPermission
    }

    // MARK: - CustomStringConvertible
    public var description: String {
        return "GPSModel(latitude: \(latitude ?? 0), longitude: \(longitude ?? 0), accuracy: \(accuracy ?? 0), gpsPermission: \(gpsPermission))"
    }

    // MARK: - JSON Parsing
    public static func from(json: [String: Any]) -> GPSModel? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }
        return try? JSONDecoder().decode(GPSModel.self, from: jsonData)
    }

    public func toJson() -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let jsonDict = jsonObject as? [String: Any] else {
            return nil
        }
        return jsonDict
    }
}

