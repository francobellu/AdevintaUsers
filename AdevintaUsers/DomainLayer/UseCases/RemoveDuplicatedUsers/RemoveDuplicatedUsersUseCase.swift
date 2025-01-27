import Foundation

class RemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> [User] {
        var seen = Set<User>()
        return users.filter { user in
            if seen.contains(user) {
                return false
            } else {
                seen.insert(user)
                return true
            }
        }
    }
}
