import Foundation

struct NameDTO: Codable {
    let title: String
    let first: String
    let last: String

    init(from name: Name) {
        self.title = name.title
        self.first = name.first
        self.last = name.last
    }

    func toDomain() -> Name {
        Name(
            title: title,
            first: first,
            last: last
        )
    }
}
