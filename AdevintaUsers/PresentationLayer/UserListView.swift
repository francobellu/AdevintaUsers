import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel // TODO: 1 use Observed Object
    @State private var selectedUser: User?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users) { user in
                    UserRowView(user: user)
                        .onAppear {
                            viewModel.loadUsers()
                        }
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

                if viewModel.isLoading {
                    ProgressView()
                        .frame(idealWidth: .infinity, alignment: .center)
                }
            }
            .searchable(text: $viewModel.searchTerm, prompt: viewModel.searchBarStr)
            .navigationTitle(viewModel.titleStr)
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user)
            }
            .alert(viewModel.errorAlertStr, isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "")
            }
        }
    }
}


#Preview("Empty State") {
    UserListView(viewModel: UserListViewModel(users: []))
}

#Preview("With Users") {
    let users = usersMocks(num: 50)
    let viewModel = UserListViewModel(users: users)
    UserListView(viewModel: viewModel)
}
