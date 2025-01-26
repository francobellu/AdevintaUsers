import Foundation

struct User: Identifiable, Hashable {
    let id: UserId
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

extension User {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(email)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email
    }
}
