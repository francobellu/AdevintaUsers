import Foundation

extension URLSession: URLSessionProtocol {}

/// `HTTPClient` is responsible for sending HTTP requests using a provided `URLSessionProtocol`.
/// It handles applying default headers, sending requests, and processing HTTP responses.
///
/// Key features:
/// - Applies default headers to requests if not already set
/// - Sends asynchronous HTTP requests and returns data types if successfull
/// - Handles various HTTP response codes and maps them to appropriate errors
/// - Provides error mapping for URLErrors to custom HTTPClientErrors
///
/// Usage:
/// ```
/// let client = HTTPClient(urlSession: URLSession.shared, configuration: config)
/// let data = try await client.sendRequest(request)
/// ```
final class HTTPClient: HTTPClientProtocol {
    let urlSession: any URLSessionProtocol
    let configuration: HTTPClientConfiguration

    init(
        urlSession: any URLSessionProtocol,
        configuration: HTTPClientConfiguration
    ) {
        self.urlSession = urlSession
        self.configuration = configuration
    }

    func sendRequest(_ request: URLRequest) async throws -> Data {
        let modifiedRequest = applyConfiguration(to: request)
        return try await performRequest(modifiedRequest)
    }
}

private extension HTTPClient {
    func applyConfiguration(to request: URLRequest) -> URLRequest {
        var modifiedRequest = request

        // Apply timeout and cache policy
        modifiedRequest.timeoutInterval = configuration.timeoutInterval
        modifiedRequest.cachePolicy = configuration.cachePolicy

        // Apply headers
        configuration.defaultHeaders.forEach { key, value in
            if modifiedRequest.value(forHTTPHeaderField: key) == nil {
                modifiedRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        return modifiedRequest
    }

    func performRequest(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(for: request)
            return try handleResponse(response, data: data)
        } catch let error as URLError {
            throw map(error: error)
        }
    }
    func handleResponse(_ response: URLResponse, data: Data)  throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 400...499:
            throw HTTPClientError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw HTTPClientError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw HTTPClientError.otherStatusCodeError(statusCode: httpResponse.statusCode)
        }
    }

    func map(error: any Error ) -> HTTPClientError {
        return switch error {
        case let error as URLError:
            switch error.code {
            case .notConnectedToInternet:
                HTTPClientError.urlErrorNoInternetConnection
            case .timedOut:
                HTTPClientError.urlErrorRequestTimeout
            default:
                HTTPClientError.urlErrorOtherError
            }
        default:
            .other
        }
    }
}
