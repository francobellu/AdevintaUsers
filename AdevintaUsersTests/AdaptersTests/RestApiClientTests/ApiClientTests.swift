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
    let stubBaseURLStr = "https://api.example.com"
    let stubEmptyJSONData = "{}".data(using: .utf8)!
    let stubInvalidJSONData = "{\"invalid\": \"json\"}".data(using: .utf8)!
    let stubResponseURL = URL(string: "https://example.com")!
    let stubErrorData = Data() // Empty data for error conditions

    let stubCorruptedData = "Invalid JSON Data".data(using: .utf8)!
    let stubInvalidJSONDataForDecodingErrorTypeMismatch = """
    {
        "results": [
            {
                "id": "912649",
                "title": "Test Movie",
                "overview": "Test Overview"
            }
        ]
    }
    """.data(using: .utf8)!

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
    @Test("Get Popular Items")
    func test_sendRequest_returnsPopularItems() async throws {
        // Given
        let jsonData = """
        {
            "results": [
                {
                    "id": 912649,
                    "title": "Test Movie",
                    "overview": "Test Overview"
                }
            ]
        }
        """.data(using: .utf8)!

        mockHttpClient.data = jsonData
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let result: TestResponse = try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get)

        // Then
        #expect(result.results.count == 1, "Should have 1 result")
        #expect(result.results[0].id == 912649, "First item ID should be 912649")
        #expect(result.results[0].title == "Test Movie", "First item title should be 'Test Movie'")
    }

    @Test("Test Headers")
    func test_sendRequest_setsCorrectHeaders() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let _: EmptyResponse = try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get)

        // Then
        let request = try #require(mockHttpClient.lastRequest)

        // Check all default headers from jsonAPI configuration
        #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json", "Content-Type header should be application/json")
        #expect(request.allHTTPHeaderFields?["Accept"] == "application/json", "Accept header should be application/json")
    }

    @Test("Test URL Parameters")
    func test_sendRequest_setsCorrectURLParameters() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.response = HTTPURLResponse(
            url: stubResponseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let _: EmptyResponse = try await sut.sendRequest(endpoint: TestEndpoint.details(123), method: .get)

        // Then
        let request = try #require(mockHttpClient.lastRequest)
        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: true))
        let queryItems = try #require(components.queryItems)

        #expect(queryItems.contains(where: { $0.name == "language" && $0.value == "en-US" }))
    }

    @Test("Test Not Found Response")
    func test_sendRequest_throwsNotFoundError() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 404)

        // When/Then
        await #expect(throws: ApiClientError.notFound) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
        }
    }

    @Test("Test Unauthorized Error")
    func test_sendRequest_throwsUnauthorizedError() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 401)

        // When/Then
        await #expect(throws: ApiClientError.unauthorized) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
        }
    }

    @Test("Test Forbidden Error")
    func test_sendRequest_throwsForbiddenError() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 403)

        // When/Then
        await #expect(throws: ApiClientError.forbidden) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
        }
    }

    @Test("Test Client Error")
    func test_sendRequest_throwsClientError() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.error = HTTPClientError.clientError(statusCode: 444)

        // When/Then
        await #expect(throws: ApiClientError.clientError(statusCode: 444)) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
        }
    }

    @Test("Test Server Error")
    func test_sendRequest_throwsServerError() async throws {
        // Given
        mockHttpClient.data = stubEmptyJSONData
        mockHttpClient.error = HTTPClientError.serverError(statusCode: 500)

        // When/Then
        await #expect(throws: ApiClientError.serverError(statusCode: 500)) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as TestResponse
        }
    }

    @Test("Test Invalid Response")
    func test_sendRequest_throwsInvalidResponse() async throws {
        // Given
        mockHttpClient.data = Data() // Empty data
        mockHttpClient.error = HTTPClientError.invalidResponse

        // When/Then
        await #expect(throws: ApiClientError.invalidResponse) {
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as EmptyResponse
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
            try await sut.sendRequest(endpoint: TestEndpoint.popular, method: .get) as TestResponse
        }
    }
}
