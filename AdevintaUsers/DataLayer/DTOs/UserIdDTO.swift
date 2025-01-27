struct UserIdDTO: Codable {
    let name: String
    let value: String?

    init(from userId: UserId) {
        self.name = userId.name
        self.value = userId.value
    }

    func toDomain() -> UserId {
        UserId(
            name: name,
            value: value ?? ""
        )
    }
}

// used in UserRepository.deleteUser
extension UserIdDTO: Equatable {
}
