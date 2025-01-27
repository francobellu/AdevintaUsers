import Foundation

struct UserDTO: Codable {
    let id: UserIdDTO
    let name: NameDTO
    let email: String
    let phone: String
    let picture: PictureDTO

    init(from user: User) {
        let userIdDTO = UserIdDTO(from: user.id)
        let nameDTO = NameDTO(from: user.name)
        let pictureDTO = PictureDTO(from: user.picture)
        self.id = userIdDTO
        self.name = nameDTO
        self.email = user.email
        self.phone = user.phone
        self.picture = pictureDTO
    }

    func toDomain() -> User {
        User(
            id: UserId(name: id.name, value: id.value ?? ""),
            name: name.toDomain(),
            email: email,
            phone: phone,
            picture: picture.toDomain()
        )
    }
}

extension UserDTO {
    static func randomMock() -> UserDTO {
        let user = User.randomMock()
        let userDTO = UserDTO(from: user)
        return userDTO
    }

    static func randomMocks(num: Int) -> [UserDTO] {
        let users = User.randomMocks(num: num)
        let userDTOs = users.map { UserDTO(from: $0) }
        return userDTOs
    }
}
