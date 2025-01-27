import Foundation

struct PictureDTO: Codable {
    let large: String

    init(from picture: Picture) {
        self.large = picture.large
    }

    func toDomain() -> Picture {
        Picture(large: large)
    }
}
