import Foundation

struct User: Identifiable, Hashable, Equatable {
    let id: UserId
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}
