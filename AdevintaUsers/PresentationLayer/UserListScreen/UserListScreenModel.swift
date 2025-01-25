import Foundation
import Combine

enum UserListScreenModelError: Error {
    case loadingFailure
    case deletionFailed
}

@MainActor
class UserListScreenModel: ObservableObject {
    @Published var asyncOp: AsyncOperation<[User]>?
    @Published var searchTerm = ""
    @Published var selectedUser: User?
    @Published var isAllSearch = true

    private let usersPerPage = 7
    var hasMorePages = true

    let deleteStr = "Delete"
    let titleStr = "Adevinta Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"
    let toogleSearchAnyStr = "Search ANY"
    let toogleSearchAllStr = "Search ALL"

    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private let deleteUserUseCase: DeleteUserUseCaseProtocol

    init(
        fetchUsersUseCase: FetchUsersUseCaseProtocol,
        deleteUserUseCase: DeleteUserUseCaseProtocol
    ) {
        self.fetchUsersUseCase = fetchUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
    }

    func loadUsers() async {
        hasMorePages = true
        do {
            let existingUsers: [User]
            if case let .success(users) = asyncOp, let users {
                // there are existing users
                existingUsers = users
            } else {
                // first load
                existingUsers = []
            }
            asyncOp = .inProgress
            let newUsers = try await fetchUsersUseCase.execute(count: usersPerPage)

            let allUsers = existingUsers + newUsers
            // TODO: also need to save them in storage... move to fetch usecase

            asyncOp = .success(result: allUsers)
        } catch {
            asyncOp = .failed(UserListScreenModelError.loadingFailure)
        }
    }

    func deleteUser(_ user: User) async {
        guard case let .success(result: users) = asyncOp,
              let users
        else { return }

        do  {
            let users = try await deleteUserUseCase.execute(user, users: users)
            asyncOp = .success(result: users)
        }
        catch {
            asyncOp = .failed(UserListScreenModelError.deletionFailed)
        }
    }


    var filteredUsers: [User]? {
        guard case let .success(users) = asyncOp else { return nil }
        guard !searchTerm.isEmpty else { return users }

        let searchTerms = searchTerm.split(separator: " ").map(String.init)

        return users?.filter { user in
            let matches = { (term: String) -> Bool in
                user.name.first.localizedCaseInsensitiveContains(term) ||
                user.name.last.localizedCaseInsensitiveContains(term) ||
                user.email.localizedCaseInsensitiveContains(term)
            }

            return isAllSearch ? searchTerms.allSatisfy(matches) : searchTerms.contains(where: matches)
        }
    }
}

extension UserListScreenModel {
    static func previewMock(
        usersResult: Result<[User], UserListScreenModelError> = .success(User.randomMocks(num: 20)),
        isLongOperation: Bool = false
    ) -> UserListScreenModel {
        let mockFetchUsersUseCase = MockFetchUsersUseCase(isLongOperation: isLongOperation)
        mockFetchUsersUseCase.usersResultStub = usersResult

        let mockDeleteUserUseCase = MockDeleteUserUseCase()
        return UserListScreenModel(
            fetchUsersUseCase: mockFetchUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase
        )
    }
}
