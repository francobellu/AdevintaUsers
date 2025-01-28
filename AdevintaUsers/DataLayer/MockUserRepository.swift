import Foundation

class MockUserRepository: UserRepositoryProtocol, @unchecked  Sendable {
    var userStubs: Result< [User], UserRepositoryError>!

    func fetchUsers(batchSize: Int, initialLoad: Bool) async throws -> [User]{
        try userStubs.get()
    }
//    func deleteUser(_ user: User) async throws {
//    }
}


