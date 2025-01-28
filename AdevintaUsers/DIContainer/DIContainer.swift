import Foundation

@MainActor
public class DIContainer {
    let usersPerBatch = 10
    let httpRequestTimeoutInterval = 30.0

    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let urlSession = URLSession.shared
    let userDefaults = UserDefaults.standard
    
    lazy var userDefaultsAdapter: UserDefaultsAdapter = {
        let userDefaultsAdapter = UserDefaultsAdapter(defaults: userDefaults)
        return userDefaultsAdapter
    }()

    lazy var userRepository: UserRepository = {
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
        let userRepository = UserRepository(apiClient: apiClient, userDefaultsAdapter: userDefaultsAdapter)
        return userRepository
    }()

    lazy var fetchUsersUseCase: FetchUsersUseCase = {

        let fetchUsersUseCase = FetchUsersUseCase(userRepository: userRepository)
        return fetchUsersUseCase
    }()

    lazy var deleteUserUseCase: DeleteUserUseCase = {
        let deleteUserUseCase = DeleteUserUseCase(userRepository: userRepository)
        return deleteUserUseCase
    }()

    lazy var getDeleteUserUseCase: GetDeletedUserUseCase = {
        let getDeleteUserUseCase = GetDeletedUserUseCase(userRepository: userRepository)
        return getDeleteUserUseCase
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
            getDeletedUserUseCase: getDeleteUserUseCase,
            removeDuplicatedUsersUseCase: removeDuplicatedUsersUseCase
        )
    }()
}
