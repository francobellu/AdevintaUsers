import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel // TODO: 1 use Observed Object

    var body: some View {
        NavigationView {
            if let asyncOp = viewModel.asyncOp {
                switch asyncOp {
                case .inProgress:
                    inProgressView()
                case .success(_):
                    if let filteredUsers = viewModel.filteredUsers {
                        successView(users: filteredUsers)
                    } else {
                        Text("No Users")
                    }
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
            VStack {
                HStack {
                    Text("Users: \(users.count)")
                    Spacer()
                    if !viewModel.searchTerm.isEmpty {
                        HStack(spacing: 4) {
                            Text(viewModel.isAllSearch ? "Search ALL" : "Search ANY")
                            Toggle("", isOn: $viewModel.isAllSearch)
                                .toggleStyle(.switch)
                                .tint(.green)
                                .labelsHidden()
                                .scaleEffect(0.75)
                                .frame(width: 40)
                        }
                    }
                }
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
                }
                .searchable(
                    text: $viewModel.searchTerm,
                    prompt: viewModel.searchBarStr
                )
                .navigationTitle(viewModel.titleStr)
                .sheet(item: $viewModel.selectedUser) { user in
                    UserDetailView(user: user)
                }
            }
        } else {
            Text("No Users")
        }
    }

    @ViewBuilder
    func helperToolbar(users: [User]) -> some View {
        HStack {
            Spacer()
            Text("Users: \(users.count)")
            Spacer()
            HStack(spacing: 4) {
                Text(viewModel.isAllSearch ? viewModel.toogleSearchAllStr : viewModel.toogleSearchAnyStr)
                Toggle("", isOn: $viewModel.isAllSearch)
                    .toggleStyle(.switch)
                    .tint(.green)
                    .labelsHidden()
                    .scaleEffect(0.75)
                    .frame(width: 40)
            }
            Spacer()
        }
    }
}

#Preview("With Users") {
    let users: [User] = User.randomMocks(num: 7)
    let usersResult =  Result<[User], UserListViewModelError> .success(users)
    UserListView(viewModel: .previewMock(usersResult: usersResult))
}

#Preview("Empty users") {
    let users: [User] = []
    let usersResult =  Result<[User], UserListViewModelError> .success(users)
    UserListView(viewModel: .previewMock(usersResult: usersResult))
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
