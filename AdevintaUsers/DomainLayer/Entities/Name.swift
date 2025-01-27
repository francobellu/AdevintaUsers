import Foundation

struct Name {
    let first: String
    let last: String
}

extension Name: Identifiable, Hashable {
    var id: String { first + "::" + last }

    func hash(into hasher: inout Hasher) {
        hasher.combine(first)
        hasher.combine(last)
    }
}
