import Foundation
import Combine

enum UserListViewModelError: Error {
    case failedToLoad
}

@MainActor
class UserListViewModel: ObservableObject {
    @Published var asyncOp: AsyncOperation<[User]>?
    @Published var searchTerm = ""

    let deleteStr = "Delete"
    let titleStr = "Adevinta Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"

    private let fetchUsersUseCase: FetchUsersUseCaseProtocol

    init(fetchUsersUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }

    func loadUsers() async{
        do {
            asyncOp = .inProgress
            let users = try await fetchUsersUseCase.execute(page: 1, count: 1)
            asyncOp =  .success(result: users)
        }
        catch {
            asyncOp = .failed(UserListViewModelError.failedToLoad)
        }
    }

    func deleteUser(_ fuser: User) async {
        print("deleteUser")
    }
}

extension UserListViewModel {
    static func previewMock(
        usersResult: Result<[User], UserListViewModelError> = .success(User.randomMocks(num: 50))
    ) -> UserListViewModel {
        let fetchUsersUseCase = MockFetchUsersUseCase()
        fetchUsersUseCase.usersResultStub = usersResult
        return UserListViewModel(fetchUsersUseCase: fetchUsersUseCase)
    }
}
