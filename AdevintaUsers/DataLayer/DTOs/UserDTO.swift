import Foundation

struct UserDTO: Codable {
    let gender: String
    let name: NameDTO
    let location: LocationDTO
    let email: String
    let login: LoginDTO
    let dob: DateInfoDTO
    let registered: DateInfoDTO
    let phone: String
    let cell: String
    let id: UserIdDTO
    let picture: PictureDTO
    let nat: String
}

extension UserDTO {
    init(from user: User) {
        self.gender = user.gender
        self.name = NameDTO(from: user.name)
        self.location = LocationDTO(from: user.location)
        self.email = user.email
        self.login = LoginDTO(from: user.login)
        self.dob = DateInfoDTO(from: user.dob)
        self.registered = DateInfoDTO(from: user.registered)
        self.phone = user.phone
        self.cell = user.cell
        self.id = UserIdDTO(from: user.userId)
        self.picture = PictureDTO(from: user.picture)
        self.nat = user.nationality
    }

    func toDomain() -> User {
        User(
            gender: gender,
            name: name.toDomain(),
            location: location.toDomain(),
            email: email,
            login: login.toDomain(),
            dob: dob.toDomain(),
            registered: registered.toDomain(),
            phone: phone,
            cell: cell,
            userId: id.toDomain(),
            picture: picture.toDomain(),
            nationality: nat
        )
    }

}
