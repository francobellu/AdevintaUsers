import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchUsers(batchSize: Int, initialLoad: Bool) async throws -> [User]
    func updateUser(_ users: [User])
}
