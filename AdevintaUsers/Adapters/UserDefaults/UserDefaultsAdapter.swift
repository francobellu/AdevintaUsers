import Foundation

protocol UserDefaultsAdapterProtocol: Sendable {
    func save(_ users: [UserDTO], for key: UserDefaultsAdapter.Key)
    func getUsers(for key: UserDefaultsAdapter.Key) -> [UserDTO]
}

// Since UserDefaults is documented as thread safe we can safely skip compiler checks  using unchecked Sendable
extension UserDefaults: @retroactive @unchecked Sendable {}

// UserDefaultsAdapter is thread safe because UserDefaults is thread safe.
final class UserDefaultsAdapter: UserDefaultsAdapterProtocol {
    enum Key: String {
        case uniqueUsers = "unique_users"
        case blacklistedUsers = "blacklisted_user"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func save(_ users: [UserDTO], for key: Key) {
        let encodedData = try? JSONEncoder().encode(users)
        defaults.set(encodedData, forKey: key.rawValue)
    }

    func getUsers(for key: Key) -> [UserDTO] {
        guard let data = defaults.data(forKey: key.rawValue),
              let users = try? JSONDecoder().decode([UserDTO].self, from: data) else {
            return []
        }
        return users
    }
}
