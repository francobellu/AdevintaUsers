import Foundation

struct UsersResponseDTO: Codable {
    let results: [UserDTO]
    let info: InfoDTO
}

extension UsersResponseDTO {
    func toDomain() -> [User] {
        results.map{$0.toDomain()}
    }
}
