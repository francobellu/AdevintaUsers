import Foundation

struct CoordinatesDTO: Codable {
    let latitude: String
    let longitude: String

    init(from coordinates: Coordinates) { 
        self.latitude = coordinates.latitude
        self.longitude = coordinates.longitude
    }

    func toDomain() -> Coordinates {
        Coordinates(
            latitude: latitude,
            longitude: longitude
        )
    }
}
