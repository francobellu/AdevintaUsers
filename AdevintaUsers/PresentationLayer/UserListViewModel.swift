import Foundation
import Combine

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []

    // TODO: Use AsyncOp
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchTerm = ""

    let deleteStr = "Delete"
    let titleStr = "Adevinta Users"
    let searchBarStr = "Search users"
    let errorAlertStr = "Error"
    init(users: [User]) {
        self.users = users
    }

    func loadUsers() {
        print("loadMoreUsersIfNeeded")
    }

    func deleteUser(_ user: User) async {
        print("deleteUser")
    }
}


