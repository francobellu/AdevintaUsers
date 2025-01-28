import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchUsers(batchSize: Int, initialLoad: Bool) async throws -> [User]
    func addToBlacklist(user: User)
    func loadBlacklist() -> [User] 
}
