struct UserIdDTO: Codable {
    let name: String?
    let value: String?  

    func toDomain() -> UserId { 
        UserId(name: name ?? "N/A", value: value ?? "N/A") 
    }
    init(from userId: UserId) {
        self.name = userId.name
        self.value = userId.value
    }
}

 
// used in UserRepository.deleteUser
extension UserIdDTO: Equatable {
}
