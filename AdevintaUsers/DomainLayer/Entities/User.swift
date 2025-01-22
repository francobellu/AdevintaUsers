import Foundation

struct User: Identifiable, Hashable {
    let id: UUID
    let name: String
    let email: String
    let phone: String
}
