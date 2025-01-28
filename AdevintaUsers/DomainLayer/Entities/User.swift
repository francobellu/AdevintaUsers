import Foundation

struct User: Identifiable{
    var id: String { userId.name + userId.value + email + name.first + name.last }
    let userId: UserId
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

extension User: Equatable, Hashable  {
    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
        hasher.combine(name)
        hasher.combine(email)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.userId == rhs.userId &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email
    }
}
