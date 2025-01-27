import Testing
import Foundation
@testable import AdevintaUsers

@Suite("HTTPClientTests")
struct HTTPClientTests {
    var sut: HTTPClient!
    var mockSession: MockURLSession!
    var mockDonfiguration: HTTPClientConfiguration

    let stubSuccessData = "Success".data(using: .utf8)!
    let stubURL = URL(string: "https://example.com")!

    init()  {
        mockSession = MockURLSession()
        mockDonfiguration = .default
        sut = HTTPClient(urlSession: mockSession, configuration: mockDonfiguration)
    }

    @Test("Successful request")
    func test_sendRequest_returnsExpectedData() async throws {
        // Given
        let expectedData = stubSuccessData
        let response = HTTPURLResponse(url: stubURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.data = expectedData
        mockSession.response = response

        // When
        let data = try await sut.sendRequest(URLRequest(url: stubURL))

        // Then
        #expect(data == expectedData)
    }

    @Test("Invalid response")
    func test_sendRequest_throwsInvalidResponse() async throws {
        // Given
        mockSession.data = Data()
        mockSession.response = URLResponse(url: stubURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)

        // When/Then
        await #expect(throws: HTTPClientError.invalidResponse) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("urlErrorNoInternetConnection")
    func test_sendRequest_throwsNoInternetConnection() async throws {
        // Given
        let error = URLError(.notConnectedToInternet)
        mockSession.error = error

        // When/Then
        await #expect(throws: HTTPClientError.urlErrorNoInternetConnection) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("urlErrorRequestTimeout")
    func test_sendRequest_throwsRequestTimeout() async throws {
        // Given
        let error = URLError(.timedOut)
        mockSession.error = error

        // When/Then
        await #expect(throws: HTTPClientError.urlErrorRequestTimeout) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("urlErrorOtherError ")
    func test_sendRequest_throwsNetworkError() async throws {
        // Given
        let error = URLError(.networkConnectionLost)
        mockSession.error = error

        // When/Then
        await #expect(throws: HTTPClientError.urlErrorOtherError) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("Client error")
    func test_sendRequest_throwsClientError() async throws {
        // Given
        mockSession.data = Data()
        let response = HTTPURLResponse(url: stubURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockSession.response = response

        // When/Then
        await #expect(throws: HTTPClientError.clientError(statusCode: 400)) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("Server error")
    func test_sendRequest_throwsServerError() async throws {
        // Given
        mockSession.data = Data()
        let response = HTTPURLResponse(url: stubURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        mockSession.response = response

        // When/Then
        await #expect(throws: HTTPClientError.serverError(statusCode: 500)) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }

    @Test("Other error")
    func test_sendRequest_throwsUnknownError() async throws {
        // Given
        mockSession.data = Data()
        let response = HTTPURLResponse(url: stubURL, statusCode: 600, httpVersion: nil, headerFields: nil)
        mockSession.response = response

        // When/Then
        await #expect(throws: HTTPClientError.otherStatusCodeError(statusCode: 600)) {
            _ = try await sut.sendRequest(URLRequest(url: stubURL))
        }
    }
}
