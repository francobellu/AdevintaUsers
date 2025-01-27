import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(batchSize: Int) async throws -> [User]
}
