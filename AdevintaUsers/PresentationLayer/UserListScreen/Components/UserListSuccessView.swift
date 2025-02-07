import SwiftUI

struct UserListSuccessView: View {
    @ObservedObject var viewModel: UserListScreenModel

    var body: some View {
        VStack {
            ToolbarView(
                usersCount: viewModel.filteredUsers.filter{ !$0.isBlacklisted }.count,
                isTyping: viewModel.isTyping,
                duplicateUsers: {viewModel.duplicatedUsers},
                blacklistedUsers: { viewModel.users.filter { $0.isBlacklisted } },
                isAllSearch: $viewModel.isAllSearch,
                showingDuplicates: $viewModel.showingDuplicates,
                showingBlacklist: $viewModel.showingBlacklist
            )
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            List {
                ForEach(viewModel.filteredUsers.filter{ !$0.isBlacklisted} ) { user in
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
                    Circle()
                        .foregroundColor(.clear)
                        .task {
                            await viewModel.onEndListReached()
                        }
                }
            }
            .listStyle(.plain)
//            .task {
//                viewModel.users.filter { $0.isBlacklisted }
//            }
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

#Preview {
    let users: [User] = User.randomMocks(num: 7)
    let usersResult =  Result<[User], UserListScreenModelError> .success(users)

    NavigationView {
        UserListSuccessView(
            viewModel: .previewMock(usersResult: usersResult)
        )
    }
}
