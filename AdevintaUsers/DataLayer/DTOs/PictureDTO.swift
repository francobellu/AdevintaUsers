import Foundation

struct PictureDTO: Codable {
    let large: String
    let medium: String
    let thumbnail: String

    init(from picture: Picture) {
        self.large = picture.large
        self.medium = picture.medium
        self.thumbnail = picture.thumbnail
    }

    func toDomain() -> Picture {
        Picture(
            large: large,
            medium: medium,
            thumbnail: thumbnail
        )
    }
}
