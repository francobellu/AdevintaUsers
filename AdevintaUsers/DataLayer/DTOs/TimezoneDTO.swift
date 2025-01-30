import Foundation

struct TimezoneDTO: Codable {
    let offset: String
    let description: String

    init(from timezone: Timezone) { 
        self.offset = timezone.offset
        self.description = timezone.description
    }

    func toDomain() -> Timezone {
        Timezone(
            offset: offset,
            description: description
        )
    }
}
