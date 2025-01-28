import Foundation

final class UserRepository: UserRepositoryProtocol {
    let apiClient: ApiClientProtocol
    let userDefaultsAdapter: UserDefaultsAdapterProtocol

    init(apiClient: ApiClientProtocol, userDefaultsAdapter: UserDefaultsAdapterProtocol) {
        self.apiClient = apiClient
        self.userDefaultsAdapter = userDefaultsAdapter
    }

    func fetchUsers(batchSize: Int, initialLoad: Bool = false) async throws -> [User] {
        // First try to get users from cache
        let cachedUsers = userDefaultsAdapter.getUsers(for: .uniqueUsers)

        // load from cache if we have cached users and initial load
        if !cachedUsers.isEmpty && initialLoad {
            return cachedUsers.map { $0.toDomain() }
        }

        // If we need more users, fetch from API
        let endpoint = UsersEndpoint.getUsers
        let usersResponseDTO: UsersResponseDTO = try await apiClient.sendRequest(endpoint: endpoint(batchSize))
        let users = extractUsersFromResponseDTO(usersResponseDTO)

        // Save new users to cache
        let newUserDTOs = users.map(UserDTO.init)
        userDefaultsAdapter.save(newUserDTOs, for: .uniqueUsers)

        return users
    }

    func addToBlacklist(user: User) {
        let userDTO = UserDTO(from: user)

        // First append the user to the cached list
        var blacklistedUsers = userDefaultsAdapter.getUsers(for: .blacklistedUsers)
        if !blacklistedUsers.contains(where: { user == $0.toDomain() }) {
            blacklistedUsers.append(userDTO)
            print("APPENDING  to blacklist: ", userDTO)
        }
        
        userDefaultsAdapter.save(blacklistedUsers, for: .blacklistedUsers)

    }

    func loadBlacklist() -> [User] {
        let cachedBlacklistedUsersDTOs = userDefaultsAdapter.getUsers(for: .blacklistedUsers)
        let cachedBlacklistedUsers = cachedBlacklistedUsersDTOs.map{$0.toDomain()}

        print("blacklist: cachedBlacklistedUsers)")
        return cachedBlacklistedUsers
    }
}

extension UserRepository {
    private func extractUsersFromResponseDTO(_ usersResponseDTO: UsersResponseDTO) -> [User] {
        let usersDTO: [UserDTO] = usersResponseDTO.results
        let users = usersDTO.map{$0.toDomain()}
        return users
    }
}
