import Foundation

/// `ApiClient` is responsible for making network requests to a specified base URL with an API key.
/// It uses a generic type `T` that conforms to `Decodable` to parse the response data.
///
/// Key features:
/// - Constructs URLs with base URL, endpoint paths, and query parameters
/// - Configures requests with appropriate HTTP methods and headers
/// - Sends requests using an underlying HTTPClientProtocol
/// - Handles response parsing and error mapping
/// - Easily expandable to supports various HTTP methods  besides GET ( POST, UPDATE etc.)
///
/// Usage:
/// ```
/// let client = ApiClient(baseURL: URL(string: "https://api.example.com")!, httpClient: HTTPClient())
/// let response: YourDecodableType = try await client.sendRequest(endpoint: .someEndpoint, method: .get)
/// ```
///
final class ApiClient: ApiClientProtocol, Sendable {
    private let configuration: ApiClientConfiguration
    private let httpClient: any HTTPClientProtocol
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(
        configuration: ApiClientConfiguration,
        httpClient: any HTTPClientProtocol,
        jsonDecoder: JSONDecoder,
        jsonEncoder: JSONEncoder

    ) {
        self.configuration = configuration
        self.httpClient = httpClient
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }

    func sendRequest<T: Decodable>(endpoint: any EndpointProtocol) async throws -> T {
        let request = try buildRequest(for: endpoint)
        dump(request)
        let data = try await performRequest(request)
        return try decodeResponse(data)
    }
}

private extension ApiClient {
    func buildRequest(for endpoint: any EndpointProtocol) throws -> URLRequest {
        let url = try buildURL(for: endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        // Apply all headers from configuration
        configuration.customHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    func buildURL(for endpoint: any EndpointProtocol) throws -> URL {
        // Get the base URL string with the endpoint path
        let urlStr = configuration.baseURLStr + endpoint.path

        // Create URL components
        var components = URLComponents(string: urlStr)
        if components == nil {
            throw ApiClientError.invalidURL
        }

        // Gather all query items
        var allQueryItems = [URLQueryItem]()

        // Add endpoint's query items if present
        if let endpointQueryItems = endpoint.queryItems {
            allQueryItems.append(contentsOf: endpointQueryItems)
        }

        // Only set query items if we have any
        if !allQueryItems.isEmpty {
            components?.queryItems = allQueryItems
        }

        // Get the final URL
        guard let url = components?.url else {
            throw ApiClientError.invalidURL
        }

        return url
    }

    func performRequest(_ request: URLRequest) async throws -> Data {
        do {
            return try await httpClient.sendRequest(request)
        } catch {
            throw handleRequestError(error)
        }
    }

    func handleRequestError(_ error: any Error) -> any Error {
        switch error {
        case let httpError as HTTPClientError:
            map(httpError)
        case is DecodingError:
            ApiClientError.decodingError
        default:
            ApiClientError.unknownError
        }
    }

    func decodeResponse<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw ApiClientError.decodingError
        }
    }

    func map(_ error: HTTPClientError) -> ApiClientError {
        switch error {
        case .clientError(let statusCode):
            switch statusCode {
            case 401: ApiClientError.unauthorized
            case 403: ApiClientError.forbidden
            case 404: ApiClientError.notFound
            default: ApiClientError.clientError(statusCode: statusCode)
            }
        case .serverError(let statusCode):
            ApiClientError.serverError(statusCode: statusCode)
        case .otherStatusCodeError(statusCode: let statusCode):
            ApiClientError.networkErrorOther(statusCode: statusCode)
        case .invalidResponse:
            ApiClientError.invalidResponse
        case .urlErrorNoInternetConnection, .urlErrorRequestTimeout:
            ApiClientError.networkError
        case .urlErrorOtherError, .other:
            ApiClientError.unknownError
        }
    }
}
