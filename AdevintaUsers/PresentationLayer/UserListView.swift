import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel // TODO: 1 use Observed Object

    var body: some View {
        NavigationView {
            if let asyncOp = viewModel.asyncOp {
                switch asyncOp {
                case .inProgress:
                    inProgressView()
                case .success(let users):
                    successView(users: users)
                case .failed(let error):
                    failedView(error: error)
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

extension UserListView {
    @ViewBuilder
    func inProgressView() -> some View {
        ProgressView()
            .frame(idealWidth: .infinity, alignment: .center)
    }

    @ViewBuilder
    func failedView(error: Error) -> some View {
        Text("Error: \(error)")
    }

    @ViewBuilder
    func successView(users: [User]?) -> some View {
        if let users {
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
            }
            .searchable(text: $viewModel.searchTerm, prompt: viewModel.searchBarStr)
            .navigationTitle(viewModel.titleStr)
            .sheet(item: $viewModel.selectedUser) { user in
                UserDetailView(user: user)
            }
        } else {
            Text("No Users")
        }
    }
}

#Preview("Empty users") {
    let users: [User] = []
    let usersResult =  Result<[User], UserListViewModelError> .success(users)
    UserListView(viewModel: .previewMock(usersResult: usersResult))
}

#Preview("With Users") {
    UserListView(viewModel: .previewMock())
}

#Preview("In Progress") {
    let usersResult: Result<[User], UserListViewModelError> = .success([])
    let viewModel: UserListViewModel = .previewMock(
        usersResult: usersResult,
        isLongOperation: true
    )
    UserListView(viewModel: viewModel)
}

#Preview("Error view") {
    let usersResult: Result<[User], UserListViewModelError> = .failure(UserListViewModelError.loadingFailure)
    let viewModel: UserListViewModel = .previewMock(
        usersResult: usersResult
    )
    UserListView(viewModel: viewModel)
}
