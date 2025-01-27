import Foundation
@testable import AdevintaUsers

// MARK: - Test Types
struct EmptyResponse: Codable {}

struct TestResponse: Codable {
    let results: [TestMovie]
}

struct TestMovie: Codable {
    let id: Int
    let title: String
    let overview: String
}

enum TestEndpoint: Hashable {
    case popular
    case details(Int)
    case custom(path: String, queryItems: [URLQueryItem])
}

extension TestEndpoint: EndpointProtocol {
    var path: String {
        switch self {
        case .popular:
            return "/3/movie/popular"
        case .details(let id):
            return "/3/movie/\(id)"
        case .custom(let path, _):
            return path
        }
    }

    var queryItems: [URLQueryItem]? {
        return switch self {
        case .popular:
            [URLQueryItem(name: "language", value: "en-US")]
        case .details:
            [URLQueryItem(name: "language", value: "en-US")]
        case .custom(_, let customItems):
            customItems
        }
    }
}

// Stubs
let stubInvalidJSONDataForDecodingErrorTypeMismatch = """
{
    "results": [
        {
            "adult": false,
            "backdrop_path": "/path_to_backdrop.jpg",
            "genre_ids": [28, 12],
            "id": "not_an_integer",
            "original_language": "en",
            "original_title": "Original Title",
            "overview": "Movie overview.",
            "popularity": 123.45,
            "poster_path": "/path_to_poster.jpg",
            "release_date": "2022-01-01",
            "title": "Movie Title",
            "video": false,
            "vote_average": 7.8,
            "vote_count": 1234
        }
    ]
}
""".data(using: .utf8)!
