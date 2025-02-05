import Foundation

class RemoveDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> (unique: [User], duplicates: [User]) {
        var seen = Set<User>()
        var duplicates = [User]()
        let uniqueUsers = users.filter { user in
            // Add debug prints
            print("Current user UUID:", user.login.uuid)
            print("Seen UUIDs:", seen.map { $0.login.uuid })
            print("Hash value:", user.hashValue)
            
            
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
