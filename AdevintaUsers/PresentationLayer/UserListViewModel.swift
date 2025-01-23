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

    let deleteStr = "Delete"
    let titleStr = "Adevinta Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"

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
            asyncOp = .success(result: users)
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
}

extension UserListViewModel {
    static func previewMock(
        usersResult: Result<[User], UserListViewModelError> = .success(User.randomMocks(num: 50)),
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
