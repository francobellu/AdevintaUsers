import Foundation

/// HTTPClientConfiguration provides basic http level configurations like request timeout interval, cache policy etc
struct HTTPClientConfiguration: Sendable {
    let defaultHeaders: [String: String]
    let timeoutInterval: TimeInterval
    let cachePolicy: URLRequest.CachePolicy

    init(
        defaultHeaders: [String: String],
        timeoutInterval: TimeInterval = 30.0,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.defaultHeaders = defaultHeaders
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }

    static var `default`: HTTPClientConfiguration {
        HTTPClientConfiguration(
            defaultHeaders: [:],
            timeoutInterval: 30.0,
            cachePolicy: .useProtocolCachePolicy
        )
    }
}

extension HTTPClientConfiguration {
    struct RequestConfiguration : Sendable{
            let cachePolicy: URLRequest.CachePolicy
            let timeoutInterval: TimeInterval
            let networkServiceType: URLRequest.NetworkServiceType

            static let `default` = RequestConfiguration(
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: 30,
                networkServiceType: .default
            )
        }

}
