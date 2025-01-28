import Foundation

protocol FetchUsersUseCaseProtocol: Sendable {
    func execute(batchSize: Int,  initialLoad: Bool) async throws -> [User]
}



