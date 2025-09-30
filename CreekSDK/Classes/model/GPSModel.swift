import UIKit

public class GPSModel: Codable {
   
    ///Multiply by 1,000,000
    public var latitude: Int?
    ///Multiply by 1,000,000
    public var longitude: Int?
    public var accuracy: Int?
    ///0 No permission 1 Permission
    public var gpsPermission: Int?

    // MARK: - Initializer
    public init(latitude: Int? = nil, longitude: Int? = nil, accuracy: Int? = nil, gpsPermission: Int? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
        self.gpsPermission = gpsPermission
    }

}

