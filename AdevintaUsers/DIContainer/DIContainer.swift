import Foundation

@MainActor
public class DIContainer {
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let urlSession = URLSession.shared

    let usersPerBatch = 7
    let httpRequestTimeoutInterval = 30.0

    lazy var fetchUsersUseCase: FetchUsersUseCase = {
        let urlSession = urlSession
        let httpClientConfiguration = HTTPClientConfiguration(
            defaultHeaders: [:],
            timeoutInterval: httpRequestTimeoutInterval,
            cachePolicy: .useProtocolCachePolicy
        )
        let httpClient = HTTPClient(urlSession: urlSession, configuration: httpClientConfiguration)
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

    lazy var userListScreenModel: UserListScreenModel =  {
        UserListScreenModel(
            usersPerBatch: usersPerBatch,
            fetchUsersUseCase: fetchUsersUseCase,
            deleteUserUseCase: deleteUserUseCase,
            removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
        )
    }()
}
