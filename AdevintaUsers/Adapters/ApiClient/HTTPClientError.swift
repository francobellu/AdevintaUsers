import Foundation

enum HTTPClientError: Error {
    case invalidResponse // not a valid Http URLResponse

    // MARK: Invalid response status codes.
    /// status code: 400...499/
    case clientError(statusCode: Int)
    /// status code: 500...599/
    case serverError(statusCode: Int)
    case otherStatusCodeError(statusCode: Int)

    // MARK: Network exceptions
    /// an URLError/
    case urlErrorNoInternetConnection
    /// an URLError
    case urlErrorRequestTimeout
    /// other URLError
    case urlErrorOtherError

    // MARK: Other exceptions
    case other
}

extension HTTPClientError: Equatable {
    static func == (lhs: HTTPClientError, rhs: HTTPClientError) -> Bool {
        switch (lhs, rhs) {
        case let (.clientError(lhsCode), .clientError(rhsCode)),
             let (.serverError(lhsCode), .serverError(rhsCode)),
             let (.otherStatusCodeError(lhsCode), .otherStatusCodeError(rhsCode)):
            lhsCode == rhsCode

        case (.invalidResponse, .invalidResponse),
             (.urlErrorNoInternetConnection, .urlErrorNoInternetConnection),
             (.urlErrorRequestTimeout, .urlErrorRequestTimeout),
             (.urlErrorOtherError, .urlErrorOtherError),
            (.other, .other):
            true
        default:
            false
        }
    }
}
