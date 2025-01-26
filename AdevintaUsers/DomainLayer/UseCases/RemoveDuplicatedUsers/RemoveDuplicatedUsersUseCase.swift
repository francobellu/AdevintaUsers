import Foundation

struct RemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> [User] {
        // Using Set to remove duplicates efficiently
        let uniqueUsers = Array(Set(users))
        return uniqueUsers
    }
}
