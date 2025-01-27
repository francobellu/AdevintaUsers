import Foundation
import Combine

enum UserListScreenModelError: Error {
    case loadingFailure
    case deletionFailed
}

@MainActor
class UserListScreenModel: ObservableObject {
    // MARK: - Observed properties
    @Published var asyncOp: AsyncOperation<[User]>?
    @Published var users: [User] = []
    @Published var searchTerm = ""
    @Published var selectedUser: User?
    @Published var isAllSearch = true

    // MARK: - Static strings
    let deleteStr = "Delete"
    let titleStr = "Adevinta Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"
    let toogleSearchAnyStr = "Search ANY"
    let toogleSearchAllStr = "Search ALL"

    var hasMorePages = true

    // MARK: - Use cases
    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol
    private let removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol

    private let usersPerPage = 7
    private var currentPage = 1
    init(
        fetchUsersUseCase: FetchUsersUseCaseProtocol,
        deleteUserUseCase: DeleteUserUseCaseProtocol,
        removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol
    ) {
        self.fetchUsersUseCase = fetchUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        self.removeDuplicatedUsersUseCase = removeDuplicatedUsersUseCase
    }

    func loadUsers() async {
        hasMorePages = true
        do {
            asyncOp = .inProgress
            let newUsers = try await fetchUsersUseCase.execute(batchSize: usersPerPage)
            users.append(contentsOf: newUsers)
            // TODO: also need to save them in storage... move to fetch usecase

            users = removeDuplicatedUsersUseCase.execute(users: users)
        } catch {
            asyncOp = .failed(UserListScreenModelError.loadingFailure)
        }
    }

    func deleteUser(_ user: User) async {
        users = deleteUserUseCase.execute(user, users: users)
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
}

// Computed properties
extension UserListScreenModel {
    var isTyping: Bool {
        !searchTerm.isEmpty
    }
}
