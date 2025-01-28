import Foundation

protocol UserDefaultsAdapterProtocol {
    func save(_ users: [UserDTO], for key: UserDefaultsAdapter.Key)
    func getUsers(for key: UserDefaultsAdapter.Key) -> [UserDTO]
}


// UserDefaultsAdapter is thread safe because UserDefaults is thread safe.
class UserDefaultsAdapter: UserDefaultsAdapterProtocol {
    enum Key: String {
        case uniqueUsers = "unique_users"
        case blacklistedUsers = "blacklisted_user"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    // Store users ( overwrites existing)
    func save(_ users: [UserDTO], for key: Key) {
        let encodedData = try? JSONEncoder().encode(users)
        defaults.set(encodedData, forKey: key.rawValue)
    }

    // Retrieve users
    func getUsers(for key: Key) -> [UserDTO] {
        guard let data = defaults.data(forKey: key.rawValue),
              let users = try? JSONDecoder().decode([UserDTO].self, from: data) else {
            return []
        }
        return users
    }
}
