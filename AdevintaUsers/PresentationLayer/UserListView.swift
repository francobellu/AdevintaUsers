import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel // TODO: 1 use Observed Object
    @State private var selectedUser: User?

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
                Text("Empty")
                    .task {
                        await viewModel.loadUsers()
                    }
            }
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
                            selectedUser = user
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
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user)
            }
        } else {
            Text("Empty")
        }
    }
}

#Preview("Empty State") {
    let users = [User]()
    let usersResult =  Result<[User], UserListViewModelError> .success(users)
    UserListView(viewModel: .previewMock(usersResult: usersResult))
}

#Preview("With Users") {
    UserListView(viewModel: .previewMock())
}
