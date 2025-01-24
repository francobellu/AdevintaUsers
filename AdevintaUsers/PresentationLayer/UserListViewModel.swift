import Foundation
import Combine

enum UserListViewModelError: Error {
    case loadingFailure
    case deletionFailed
}

@MainActor
class UserListViewModel: ObservableObject {
    @Published var asyncOp: AsyncOperation<[User]>?
    @Published var searchTerm = ""
    @Published var selectedUser: User?
    @Published var isAllSearch = true

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

    func loadUsers() async{
        do {
            asyncOp = .inProgress
            let users = try await fetchUsersUseCase.execute(page: 1, count: 1)
            // TODO: also need to save them in storage... move to fetch usecase
            if case let .success(existingUsers) = asyncOp,
               let existingUsers {
                asyncOp = .success(result: existingUsers + users)
            } else {
                asyncOp = .success(result: users)
            }
        }
        catch {
            asyncOp = .failed(UserListViewModelError.loadingFailure)
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
            asyncOp = .failed(UserListViewModelError.deletionFailed)
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

extension UserListViewModel {
    static func previewMock(
        usersResult: Result<[User], UserListViewModelError> = .success(User.randomMocks(num: 20)),
        isLongOperation: Bool = false
    ) -> UserListViewModel {
        let mockFetchUsersUseCase = MockFetchUsersUseCase(isLongOperation: isLongOperation)
        mockFetchUsersUseCase.usersResultStub = usersResult

        let mockDeleteUserUseCase = MockDeleteUserUseCase()
        return UserListViewModel(
            fetchUsersUseCase: mockFetchUsersUseCase,
            deleteUserUseCase: mockDeleteUserUseCase
        )
    }
}
