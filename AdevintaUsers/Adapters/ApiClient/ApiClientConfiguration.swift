import Foundation

/// Containing API-specific settings like baseUrl,  headers used across all the he API endpoints
struct ApiClientConfiguration: Sendable{
    // API-specific settings
    let baseURLStr: String
    let customHeaders: [String: String]

    init(
        headers: [String: String] = [:],
        baseURLStr: String
    ) {
        self.baseURLStr = baseURLStr
        self.customHeaders = headers
    }

    // Default configuration for JSON APIs
    static func `default`() -> ApiClientConfiguration {
        let baseURLStr = "https://randomuser.me/api"
        return ApiClientConfiguration(
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            baseURLStr: baseURLStr
        )
    }
}
