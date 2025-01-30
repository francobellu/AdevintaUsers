import Foundation

struct StreetDTO: Codable {
    let number: Int
    let name: String

    init(from street: Street) { 
        self.number = street.number
        self.name = street.name
    }

    func toDomain() -> Street {
        Street(number: number, name: name)
    }
}
