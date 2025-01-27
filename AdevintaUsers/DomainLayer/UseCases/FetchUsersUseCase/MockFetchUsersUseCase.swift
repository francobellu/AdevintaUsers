import Foundation

final class MockFetchUsersUseCase: FetchUsersUseCaseProtocol, @unchecked Sendable {
    var usersResultStub: Result <[User], UserListScreenModelError>!
    var usersResultFactory: (() -> Result <[User], UserListScreenModelError>)!
    var isLongOperation: Bool

    init(isLongOperation: Bool = false) {
        self.isLongOperation = isLongOperation
    }

    func execute(batchSize: Int) async throws -> [User] {
        let result: [User]
        if isLongOperation {
            try await Task.sleep(for: .seconds(100))
        }
        if let usersResultFactory {
            result = try usersResultFactory().get()
        } else {
            result = try usersResultStub.get()
        }
        return result
    }
}
