import SwiftUI

@main
struct AdevintaUsersApp: App {
    let diContainer = DIContainer()

    init() {
        print("Home directory: ", NSHomeDirectory())
    }
    var body: some Scene {
        WindowGroup {
            let viewModel = diContainer.userListScreenModel
            UserListScreen(viewModel: viewModel)
        }
    }
}
