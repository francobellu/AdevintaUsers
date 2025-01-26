import Foundation

struct RemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) async throws -> [User] {
        // Using Set to remove duplicates efficiently
        let uniqueUsers = Array(Set(users))
        return uniqueUsers
    }
}
