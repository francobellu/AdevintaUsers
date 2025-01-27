@testable import AdevintaUsers
import Testing

@Suite("DeleteUserUseCase Tests")
struct RemoveDuplicatedUsersUseCaseTests {
    let sut: RemoveDuplicatedUsersUseCase

    // Stubs
    let userJohnDoe =                  User(id: UserId(name: "John", value: "AAA"), name: Name(first: "John", last: "Doe"), email: "john@example.com", phone: "12", picture: Picture(large: "xxx"))
    let userJohnDoe_differentId =      User(id: UserId(name: "John", value: "BBB"), name: Name(first: "John", last: "Doe"), email: "john@example.com", phone: "12", picture: Picture(large: "xxx"))
    let userJohnDoe_differentName =    User(id: UserId(name: "John", value: "AAA"), name: Name(first: "John", last: "Smith"), email: "john@example.com", phone: "12", picture: Picture(large: "xxx"))
    let userJohnDoe_differentEmail =   User(id: UserId(name: "John", value: "AAA"), name: Name(first: "John", last: "Doe"), email: "johnAA@example.com", phone: "12", picture: Picture(large: "xxx"))
    let userJohnDoe_differentTel =     User(id: UserId(name: "John", value: "AAA"), name: Name(first: "John", last: "Doe"), email: "john@example.com", phone: "99", picture: Picture(large: "xxx"))


    init() {
        sut = RemoveDuplicatedUsersUseCase()
    }

    @Test("test that with users with 2 exactly same, one is removed")
    func test_execute_exactlySameUserIsRemoved() async throws {
        // Given
        var users: [User] = [userJohnDoe, userJohnDoe]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When

        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount - 1)
        #expect(duplicates.count == 1)
    }

    @Test("test_execute_userWithDifferentIdIsNotRemoved")
    func test_execute_userWithDifferentIdIsNotRemoved() async throws {
        // Given
        var users: [User] = [userJohnDoe, userJohnDoe_differentId]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount)
        #expect(duplicates.count == 0)
    }

    @Test("")
    func test_execute_userWithDifferentEmailIsNoRemoved() async throws {
        // Given
        var users: [User] = [userJohnDoe, userJohnDoe_differentEmail]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount)
        #expect(duplicates.count == 0)
    }

    @Test("test_execute_userWithDifferentNameIsNoRemoved")
    func test_execute_userWithDifferentNameIsNoRemoved() async throws {
        // Given
        var users: [User] = [userJohnDoe, userJohnDoe_differentName]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount)
        #expect(duplicates.count == 0)
    }

    @Test("test_execute_userWithDifferentTelephoneIsRemoved")
    func test_execute_userWithDifferentTelephoneIsRemoved() async throws {
        // Given
        var users: [User] = [userJohnDoe, userJohnDoe_differentTel]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount - 1)
        #expect(duplicates.count == 1)
    }
}

