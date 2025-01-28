import SwiftUI

struct UserListScreen: View {
    @ObservedObject var viewModel: UserListScreenModel
    var body: some View {
        NavigationView {
            ZStack {
                UserListSuccessView(viewModel: viewModel)
                if let asyncOp = viewModel.asyncOp {
                    switch asyncOp {
                    case .inProgress:
                        UserListProgressView()
                    case .failed(let error ):
                        if let error = error as? UserListScreenModelError {
                            ErrorView(
                                userMessage: error.userMessage,
                                onRetry: {
                                    Task{
                                        await viewModel.loadUsers()
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .task {
                await viewModel.loadUsers()
            }
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
