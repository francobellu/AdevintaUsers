import Foundation

struct User: Identifiable{
    var id: String { login.uuid }
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateInfo
    let registered: DateInfo
    let phone: String
    let cell: String
    let userId: UserId
    let picture: Picture
    let nationality: String
}

extension User: Equatable, Hashable  {
    func hash(into hasher: inout Hasher) {
        hasher.combine(login.uuid)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.login.uuid == rhs.login.uuid
    }
}
