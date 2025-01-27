import Foundation

final class Token {}
public func loadMockData(fromFile fileName: String) -> Data {
    let bundle = Bundle(for: Token.self)
    guard let url = bundle.url(
        forResource: fileName,
        withExtension: "json"
    ),
        let data = try? Data(contentsOf: url)
    else {
        fatalError("Failed to load mock data from file: \(fileName).json")
    }
    return data
}
