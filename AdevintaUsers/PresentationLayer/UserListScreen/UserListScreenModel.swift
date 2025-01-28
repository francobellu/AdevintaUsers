import Foundation
import Combine

enum UserListScreenModelError: Error {
    case loadingFailure
    case deletionFailed

    var userMessage: String {
        switch self {
        case .loadingFailure:
            return "Unable to load users. \nPlease check your connection and try again."
        case .deletionFailed:
            return "Failed to delete user. \nPlease try again."
        }
    }
}

@MainActor
final class UserListScreenModel: ObservableObject {
    // MARK: - Observed properties
    @Published var asyncOp: AsyncOperation<[User]>?
    @Published var users: [User] = []
    @Published var duplicatedUsers: [User] = []
    @Published var blacklistedUsers: [User] = []
    @Published var searchTerm = ""
    @Published var selectedUser: User?
    @Published var isAllSearch = true
    @Published var showingDuplicates = false
    @Published var showingBlacklist = false

    // MARK: - Static strings
    let deleteStr = "Delete"
    let titleStr = "RandomUser Inc. Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"
    let toogleSearchAnyStr = "Search ANY"
    let toogleSearchAllStr = "Search ALL"

    var hasMorePages = true

    // MARK: - Use cases
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol

    private let usersPerBatch: Int
    init(
        usersPerBatch: Int,
        fetchUsersUseCase: FetchUsersUseCaseProtocol,
        deleteUserUseCase: DeleteUserUseCaseProtocol,
        removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol
    ) {
        self.usersPerBatch = usersPerBatch
        self.fetchUsersUseCase = fetchUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.removeDuplicatedUsersUseCase = removeDuplicatedUsersUseCase
    }

    func loadUsers() async {
        if case .inProgress = asyncOp { return }
        hasMorePages = true
        do {
            asyncOp = .inProgress
            let initialLoad = users.isEmpty
            let newUsers = try await fetchUsersUseCase.execute(batchSize: usersPerBatch, initialLoad: initialLoad)
            users.append(contentsOf: newUsers)

            let (uniqueUsers, duplicates) = removeDuplicatedUsersUseCase.execute(users: users)
            // TODO: also need to filter out blacklisted users
            users = uniqueUsers
            if !duplicates.isEmpty {
                duplicatedUsers.append(contentsOf: duplicates)
            }

            asyncOp = .none
        } catch {
            asyncOp = .failed(UserListScreenModelError.loadingFailure)
        }
    }

    func deleteUser(_ user: User) async {
        users = deleteUserUseCase.execute(user, users: users)
        blacklistedUsers.append(user)
    }


    var filteredUsers: [User] {
        guard !searchTerm.isEmpty else { return users }

        let searchTerms = searchTerm.split(separator: " ").map(String.init)

        return users.filter { user in
            let matches = { (term: String) -> Bool in
                user.name.first.localizedCaseInsensitiveContains(term) ||
                user.name.last.localizedCaseInsensitiveContains(term) ||
                user.email.localizedCaseInsensitiveContains(term)
            }

            return isAllSearch ? searchTerms.allSatisfy(matches) : searchTerms.contains(where: matches)
        }
    }

    var displayedUsers: [User] {
        if showingDuplicates {
            return duplicatedUsers
        } else if showingBlacklist {
            return blacklistedUsers
        } else {
            return filteredUsers
        }
    }
}

// Computed properties
extension UserListScreenModel {
    var isTyping: Bool {
        !searchTerm.isEmpty
    }
}
