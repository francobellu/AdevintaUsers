import Foundation

protocol RemoveDuplicatedUsersUseCaseProtocol {
    func execute(users: [User]) -> (unique: [User], duplicates: [User]) 
}
