import SwiftUI

struct UserListSuccessView: View {
    @ObservedObject var viewModel: UserListScreenModel
    let users: [User]

    var body: some View {
        VStack {
            HelperToolbarView(usersCount: users.count, isTyping: viewModel.searchTerm.isEmpty, isAllSearch: $viewModel.isAllSearch)
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
            viewModel: .previewMock(usersResult: usersResult),
            users: User.randomMocks(num: 7)
        )
    }
}
