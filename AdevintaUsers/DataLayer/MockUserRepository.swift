import Foundation

class MockUserRepository: UserRepositoryProtocol, @unchecked  Sendable {
    func updateUser(_ users: [User]) {
    }
    
    var userStubs: Result< [User], UserRepositoryError>!

    func fetchUsers(batchSize: Int, initialLoad: Bool) async throws -> [User]{
        try userStubs.get()
    }

    func addToBlacklist(user: User) {
    }
    
    func loadBlacklist() -> [User] {
        fatalError(#function) // Not implemented
    }
}


