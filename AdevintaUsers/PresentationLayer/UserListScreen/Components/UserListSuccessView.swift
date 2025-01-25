//import SwiftUI
//
//struct UserListSuccessView: View {
//    @ObservedObject var viewModel: UserListScreenModel
//    let users: [User]
//
//    var body: some View {
//        VStack {
//            ToolbarView(usersCount: users.count, isTyping: viewModel.searchTerm.isEmpty, isAllSearch: $viewModel.isAllSearch)
//                .padding(.horizontal)
//                .frame(maxWidth: .infinity)
//            List {
//                ForEach(users) { user in
//                    UserRowView(user: user)
//                        .onTapGesture {
//                            viewModel.selectedUser = user
//                        }
//                        .swipeActions {
//                            Button(role: .destructive) {
//                                Task {
//                                    await viewModel.deleteUser(user)
//                                }
//                            } label: {
//                                Label(viewModel.deleteStr, systemImage: "trash")
//                            }
//                        }
//                }
//                if viewModel.hasMorePages {
//                    ProgressView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .foregroundColor(.black)
//                        .foregroundColor(.red)
//                        .task {
//                            await viewModel.loadUsers()
//                        }
//                }
//            }
//            .searchable(
//                text: $viewModel.searchTerm,
//                prompt: viewModel.searchBarStr
//            )
//            .navigationTitle(viewModel.titleStr)
//            .sheet(item: $viewModel.selectedUser) { user in
//                UserDetailScreen(user: user)
//            }
//        }
//    }
//}
//
//#Preview {
//    let users: [User] = User.randomMocks(num: 7)
//    let usersResult =  Result<[User], UserListScreenModelError> .success(users)
//
//    NavigationView {
//        UserListSuccessView(
//            viewModel: .previewMock(usersResult: usersResult),
//            users: User.randomMocks(num: 7)
//        )
//    }
//}
//
//
//struct ContentView: View {
//  @State private var numbers: [Int] = Array(1...20)
//  @State private var isLoading = false
//  @State private var isFinished = false
//
//  var body: some View {
//    NavigationStack {
//      List {
//        ForEach(numbers, id: \.self) { number in
//          Text("Row \(number)")
//        }
//
//        if !isFinished {
//          ProgressView()
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .foregroundColor(.black)
//            .foregroundColor(.red)
//            .onAppear {
//              loadMoreContent()
//            }
//        }
//      }
//      .navigationTitle("Infinite List")
//    }
//  }
//
//  func loadMoreContent() {
//    if !isLoading {
//      isLoading = true
//      // This simulates an asynchronus call
//      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//        let moreNumbers = numbers.count + 1...numbers.count + 20
//        numbers.append(contentsOf: moreNumbers)
//        isLoading = false
//        if numbers.count > 250 {
//          isFinished = true
//        }
//      }
//    }
//  }
//}
//
//#Preview("ContentView") {
//    ContentView()
//}
