import Foundation

struct DateInfoDTO: Codable {
    let date: String
    let age: Int

    init(from dateInfo: DateInfo) {
        let isoFormatter = ISO8601DateFormatter()
        self.date = isoFormatter.string(from: dateInfo.date)
        self.age = dateInfo.age
    }

    func toDomain() -> DateInfo {
        let isoFormatter = ISO8601DateFormatter()
        return DateInfo(
            date: isoFormatter.date(from: date) ?? Date(),
            age: age
        )
    }
}
