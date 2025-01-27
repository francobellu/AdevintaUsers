import Foundation

public enum ApiClientError: Error {
    // Typical api errors
    case invalidURL
    case decodingError
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    /// status code: 400...499
    case clientError(statusCode: Int)
    /// status code: 500...599/
    case serverError(statusCode: Int)
    case networkError
    case networkErrorOther(statusCode: Int)
    case unknownError
}

extension ApiClientError: Equatable {
    public static func == (lhs: ApiClientError, rhs: ApiClientError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.unauthorized, .unauthorized),
            (.forbidden, .forbidden),
            (.notFound, .notFound),
            (.networkError, .networkError),
            (.unknownError, .unknownError),
            (.invalidResponse, .invalidResponse),
            (.decodingError, .decodingError):
            return true
        case (.clientError(let lhsCode), .clientError(let rhsCode)):
            return lhsCode == rhsCode
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.networkErrorOther(let lhsCode), .networkErrorOther(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
