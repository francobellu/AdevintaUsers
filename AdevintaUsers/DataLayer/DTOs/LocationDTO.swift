import Foundation

struct LocationDTO: Codable {
    let street: StreetDTO
    let city: String
    let state: String
    let country: String
    let postcode: String 
    let coordinates: CoordinatesDTO
    let timezone: TimezoneDTO

    init(from location: Location) {
        self.street = StreetDTO(from: location.street)
        self.city = location.city
        self.state = location.state
        self.country = location.country
        self.postcode = location.postcode
        self.coordinates = CoordinatesDTO(from: location.coordinates)
        self.timezone = TimezoneDTO(from: location.timezone)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        street = try container.decode(StreetDTO.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        coordinates = try container.decode(CoordinatesDTO.self, forKey: .coordinates)
        timezone = try container.decode(TimezoneDTO.self, forKey: .timezone)

        if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            postcode = String(postcodeInt)
        } else {
            postcode = try container.decode(String.self, forKey: .postcode)
        }
    }

    func toDomain() -> Location {
        Location(
            street: street.toDomain(),
            city: city,
            state: state,
            country: country,
            postcode: postcode,
            coordinates: coordinates.toDomain(),
            timezone: timezone.toDomain()
        )
    }
}
