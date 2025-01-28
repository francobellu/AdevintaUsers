import Foundation

class RemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> (unique: [User], duplicates: [User]) {
        var seen = Set<User>()
        var duplicates = [User]()
        let uniqueUsers = users.filter { user in
            if seen.contains(user) {
                duplicates.append(user)
                return false
            } else {
                seen.insert(user)
                return true
            }
        }

        print("Unique: ", uniqueUsers)
        print("\nduplicates", duplicates)
        return (unique: uniqueUsers, duplicates: duplicates)
    }
}

