import SwiftUI

struct UserListScreen: View {
    @StateObject var viewModel: UserListScreenModel // TODO: 1 use Observed Object

    var body: some View {
        NavigationView {
            if let asyncOp = viewModel.asyncOp {
                switch asyncOp {
                case .inProgress:
                    UserListProgressView()
                case .success(_):
                    if let filteredUsers = viewModel.filteredUsers {
                        UserListSuccessView(viewModel: viewModel, users: filteredUsers)
                    } else {
                        Text("No Users")
                    }
                case .failed(let error):
                    UserListFailedView(error: error)
                        .alert(viewModel.errorAlertStr, isPresented: .constant(viewModel.asyncOp == .failed(error))) {
                            Button("OK") {
                                viewModel.asyncOp = nil
                            }
                        } message: {
                            Text(error.localizedDescription)
                        }
                }
            }
            else {
                Text("No Users")
            }
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}

#Preview("With Users") {
    let users: [User] = User.randomMocks(num: 7)
    let usersResult =  Result<[User], UserListScreenModelError> .success(users)
    UserListScreen(viewModel: .previewMock(usersResult: usersResult))
}

#Preview("Empty users") {
    let users: [User] = []
    let usersResult =  Result<[User], UserListScreenModelError> .success(users)
    UserListScreen(viewModel: .previewMock(usersResult: usersResult))
}

#Preview("In Progress") {
    let usersResult: Result<[User], UserListScreenModelError> = .success([])
    let viewModel: UserListScreenModel = .previewMock(
        usersResult: usersResult,
        isLongOperation: true
    )
    UserListScreen(viewModel: viewModel)
}

#Preview("Error view") {
    let usersResult: Result<[User], UserListScreenModelError> = .failure(UserListScreenModelError.loadingFailure)
    let viewModel: UserListScreenModel = .previewMock(
        usersResult: usersResult
    )
    UserListScreen(viewModel: viewModel)
}
