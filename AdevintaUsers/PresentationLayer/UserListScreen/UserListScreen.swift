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
                        successView(users: filteredUsers)
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
        .padding(.horizontal, 16)
        .task {
            await viewModel.loadUsers()
        }
    }

    @ViewBuilder
    func successView(users: [User]) -> some View {
        VStack {
            ToolbarView(usersCount: users.count, isTyping: viewModel.searchTerm.isEmpty, isAllSearch: $viewModel.isAllSearch)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            List {
                ForEach(users) { user in
                    UserRowView(user: user)
                        .onTapGesture {
                            viewModel.selectedUser = user
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteUser(user)
                                }
                            } label: {
                                Label(viewModel.deleteStr, systemImage: "trash")
                            }
                        }
                }
                if viewModel.hasMorePages {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.black)
                        .foregroundColor(.red)
                        .task {
                            await viewModel.loadUsers()
                        }
                }
            }
            .searchable(
                text: $viewModel.searchTerm,
                prompt: viewModel.searchBarStr
            )
            .navigationTitle(viewModel.titleStr)
            .sheet(item: $viewModel.selectedUser) { user in
                UserDetailScreen(user: user)
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
