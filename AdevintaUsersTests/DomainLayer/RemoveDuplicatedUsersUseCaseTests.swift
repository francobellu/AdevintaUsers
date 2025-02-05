@testable import AdevintaUsers
import Testing
import Foundation

@Suite("RemoveDuplicatedUsersUseCase Tests")
struct RemoveDuplicatedUsersUseCaseTests {
    let sut: RemoveDuplicatedUsersUseCase

    init() {
        sut = RemoveDuplicatedUsersUseCase()
    }

    @Test("test that with users with 2 exactly same, one is removed")
    func test_execute_exactlySameUserIsRemoved() async throws {
        // Given
        var users: [User] = [.userJohnDoe(), .userJohnDoe()]
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
        var users: [User] = [.userJohnDoe(), .userJohnDoe_differentId()]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount)
        #expect(duplicates.count == 0)
    }

    @Test("test_execute_userWithDifferentEmailIsRemoved") // still same login.uuid
    func test_execute_userWithDifferentEmailIsRemoved() async throws {
        // Given
        var users: [User] = [.userJohnDoe(), .userJohnDoe_differentEmail()]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount - 1)
        #expect(duplicates.count == 1)
    }

    @Test("test_execute_userWithDifferentNameIsNoRemoved") // still same login.uuid
    func test_execute_userWithDifferentNameIsRemoved() async throws {
        // Given
        var users: [User] = [.userJohnDoe(), .userJohnDoe_differentName()]
        let initialUserCount = users.count
        try #require(users.count == initialUserCount)

        // When
        let ( uniqueUsers, duplicates) = sut.execute(users: users)
        users = uniqueUsers

        // Them
        #expect(users.count == initialUserCount - 1)
        #expect(duplicates.count == 1)
    }

    @Test("test_execute_userWithDifferentTelephoneIsRemoved") // still same login.uuid
    func test_execute_userWithDifferentTelephoneIsRemoved() async throws {
        // Given
        var users: [User] = [.userJohnDoe(), .userJohnDoe_differentTel()]
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
