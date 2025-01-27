import Foundation

/// HTTPClientConfiguration provides basic http level configurations like request timeout interval, cache policy etc
struct HTTPClientConfiguration: Sendable {
    let defaultHeaders: [String: String]
    let timeoutInterval: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    init(
        defaultHeaders: [String: String],
        timeoutInterval: TimeInterval,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.defaultHeaders = defaultHeaders
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
}
