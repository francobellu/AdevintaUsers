import Foundation

protocol UserRepositoryProtocol {
    func fetchUsers(page: Int, count: Int) async throws -> [User]
    func deleteUser(_ user: User) async throws
}
