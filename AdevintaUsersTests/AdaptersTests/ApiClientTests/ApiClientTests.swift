import Foundation
import Testing
@testable import AdevintaUsers

@Suite("ApiClientTests")
struct ApiClientTests {
    // MARK: - Properties
    var sut: ApiClient!
    var mockHttpClient: MockHttpClient
    var jsonDecoder = JSONDecoder()
    var jsonEncoder = JSONEncoder()

    // MARK: - Test Stubs
    let stubInvalidJSONData = "{\"invalid\": \"json\"}".data(using: .utf8)!

    let stubResponseURL = URL(string: "https://example.com")!

    let stubInvalidJSONDataForDecodingErrorTypeMismatch = """
    {
        "results": ""
    }
    """.data(using: .utf8)!

    let getUsersEndpoint = UsersEndpoint.getUsers(batchSize: 10)


    // MARK: - Initialization
    init() {
        mockHttpClient = MockHttpClient()
        let config = ApiClientConfiguration.default()
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        sut = ApiClient(
            configuration: config,
            httpClient: mockHttpClient,
            jsonDecoder: jsonDecoder,
            jsonEncoder: jsonEncoder
        )
    }

    // MARK: - Tests
    @Test("Test Get Users")
    func test_sendRequest_returnsUsers() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")

        mockHttpClient.data = jsonData
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let response: UsersResponseDTO = try await sut.sendRequest(endpoint: getUsersEndpoint)

        // Then
        #expect(response.results.count == 1, "Should have 1 result")
        #expect(response.results[0].name.first == "Jennie")
        #expect(response.results[0].name.last == "Nichols")
    }

    @Test("Test Headers")
    func test_sendRequest_setsCorrectHeaders() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData

        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let _: UsersResponseDTO =  try await sut.sendRequest(endpoint: getUsersEndpoint)

        // Then
        let request = try #require(mockHttpClient.lastRequest)

        // Check all default headers from jsonAPI configuration
        #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json", "Content-Type header should be application/json")
        #expect(request.allHTTPHeaderFields?["Accept"] == "application/json", "Accept header should be application/json")
    }

    @Test("Test URL Parameters")
    func test_sendRequest_setsCorrectURLParameters() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let _: UsersResponseDTO =  try await sut.sendRequest(endpoint: getUsersEndpoint)

        // Then
        let request = try #require(mockHttpClient.lastRequest)
        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: true))
        let queryItems = try #require(components.queryItems)

        #expect(queryItems.contains(where: { $0.name == "results" && $0.value == "10" }))
    }

    @Test("Test Not Found Response")
    func test_sendRequest_throwsNotFoundError() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 404)

        // When/Then
        await #expect(throws: ApiClientError.notFound) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Unauthorized Error")
    func test_sendRequest_throwsUnauthorizedError() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 401)

        // When/Then
        await #expect(throws: ApiClientError.unauthorized) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Forbidden Error")
    func test_sendRequest_throwsForbiddenError() async throws {
        // Given
       let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 403)

        // When/Then
        await #expect(throws: ApiClientError.forbidden) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Client Error")
    func test_sendRequest_throwsClientError() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 444)

        // When/Then
        await #expect(throws: ApiClientError.clientError(statusCode: 444)) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Server Error")
    func test_sendRequest_throwsServerError() async throws {
        // Given
        let jsonData = loadMockData(fromFile: "UsersSuccess")
        mockHttpClient.data = jsonData
        mockHttpClient.error = HTTPClientError.serverError(statusCode: 500)

        // When/Then
        await #expect(throws: ApiClientError.serverError(statusCode: 500)) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Unknown Error")
    func test_sendRequest_throwsUnknownError() async throws {
        // Given
        mockHttpClient.error = HTTPClientError.urlErrorOtherError
        mockHttpClient.data = nil
        mockHttpClient.response = nil

        // When/Then
        await #expect(throws: ApiClientError.unknownError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test No Internet Connection Error")
    func test_sendRequest_throwsNoInternetConnectionError() async throws {
        // Given
        mockHttpClient.error = HTTPClientError.urlErrorNoInternetConnection
        mockHttpClient.data = nil
        mockHttpClient.response = nil

        // When/Then
        await #expect(throws: ApiClientError.networkError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Request Timeout Error")
    func test_sendRequest_throwsRequestTimeoutError() async throws {
        // Given
        mockHttpClient.error = HTTPClientError.urlErrorRequestTimeout
        mockHttpClient.data = nil
        mockHttpClient.response = nil

        // When/Then
        await #expect(throws: ApiClientError.networkError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Other Network Error")
    func test_sendRequest_throwsOtherNetworkError() async throws {
        // Given
        mockHttpClient.error = HTTPClientError.urlErrorOtherError
        mockHttpClient.data = nil
        mockHttpClient.response = nil

        // When/Then
        await #expect(throws: ApiClientError.unknownError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Decoding Error")
    func test_sendRequest_throwsDecodingError() async throws {
        // Given
        // The JSON data contains a string where an Int is expected for "id".
        mockHttpClient.data = stubInvalidJSONDataForDecodingErrorTypeMismatch
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        mockHttpClient.error = nil

        // When/Then
        await #expect(throws: ApiClientError.decodingError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Invalid Response")
    func test_sendRequest_throwsInvalidResponse() async throws {
        // Given
        mockHttpClient.data = Data() // Empty data
        mockHttpClient.error = HTTPClientError.invalidResponse

        // When/Then
        await #expect(throws: ApiClientError.invalidResponse) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }

    @Test("Test Empty Data Decoding Error")
    func test_sendRequest_throwsDecodingErrorForEmptyData() async throws {
        // Given
        mockHttpClient.data = Data() // Empty data
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then
        await #expect(throws: ApiClientError.decodingError) {
            try await sut.sendRequest(endpoint: getUsersEndpoint) as UsersResponseDTO
        }
    }
}
