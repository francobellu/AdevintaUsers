import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchUsers(batchSize: Int) async throws -> [User]
}
