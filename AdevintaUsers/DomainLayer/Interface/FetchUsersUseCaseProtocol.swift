import Foundation

protocol FetchUsersUseCaseProtocol: Sendable {
    func execute(batchSize: Int) async throws -> [User]
}



