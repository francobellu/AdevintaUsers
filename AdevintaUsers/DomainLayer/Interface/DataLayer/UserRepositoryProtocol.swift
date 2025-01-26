import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(batchSize: Int, page: Int) async throws -> [User]
}
