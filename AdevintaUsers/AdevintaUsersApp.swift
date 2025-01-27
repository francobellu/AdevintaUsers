//
//  AdevintaUsersApp.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 22/1/25.
//

import SwiftUI

@main
struct AdevintaUsersApp: App {
    // TODO: use DIContainer
    let fetchUsersUseCase: FetchUsersUseCase = {
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        let urlSession = URLSession.shared
        let configuration = HTTPClientConfiguration.default
        let httpClient = HTTPClient(urlSession: urlSession, configuration: configuration)
        let apiClientConfiguration = ApiClientConfiguration.default()
        let apiClient = ApiClient(
            configuration: apiClientConfiguration,
            httpClient: httpClient,
            jsonDecoder: jsonDecoder,
            jsonEncoder: jsonEncoder
        )
        let userRepository = UserRepository(apiClient: apiClient)

        let fetchUsersUseCase = FetchUsersUseCase(userRepository: userRepository)
        return fetchUsersUseCase
    }()

    let deleteUserUseCase: DeleteUserUseCase = {
        let deleteUserUseCase = DeleteUserUseCase()
        return deleteUserUseCase
    }()

    let removeDuplicatedUsersUseCase: RemoveDuplicatedUsersUseCase = {
        let removeDuplicatedUsersUseCase = RemoveDuplicatedUsersUseCase()
        return removeDuplicatedUsersUseCase
    }()

    let usersPerBatch = 7
    
    var body: some Scene {
        WindowGroup {
            let viewModel = UserListScreenModel(
                usersPerBatch: usersPerBatch,
                fetchUsersUseCase: fetchUsersUseCase,
                deleteUserUseCase: deleteUserUseCase,
                removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
            )
            UserListScreen(viewModel: viewModel)
        }
    }
}
