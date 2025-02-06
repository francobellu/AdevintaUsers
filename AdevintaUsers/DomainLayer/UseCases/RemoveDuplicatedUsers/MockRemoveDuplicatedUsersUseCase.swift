import Foundation

class MockRemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> (unique: [User], duplicates: [User]) {
        (unique: users, duplicates: [])
    }
}
