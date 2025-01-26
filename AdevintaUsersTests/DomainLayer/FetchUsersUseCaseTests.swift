//
//  Untitled.swift
//  AdevintaUsers
//
//  Created by Franco Bellu on 26/1/25.
//

@testable import AdevintaUsers
import Testing
import Foundation

@Suite("FetchUsersUseCaseTests Tests")
struct FetchUsersUseCaseTests {
    let sut: FetchUsersUseCase
    var mockUserRepository: MockUserRepository

    let batchSize = 10
    var page = 1

    // Stubs
    var successResul: Result<[User], UserRepositoryError> = .success( User.randomMocks(num: 10))
    var networkingErrorResult: Result<[User], UserRepositoryError> = .failure( .networking(NSError(domain: "test", code: 0)))


    init() {
        mockUserRepository = MockUserRepository()
        sut = FetchUsersUseCase(userRepository: mockUserRepository)
    }

    @Test("Test fetching users returns a some users")
    func test_execute() async throws {
        // Given
        mockUserRepository.userStubs = successResul

        // When
        let result = try await sut.execute(batchSize: batchSize, page: page)

        // Then
        #expect(!result.isEmpty, "The user array should not be empty")
    }

    @Test("Test fetching users throws a networking error")
    mutating func test_execute_throwsNetworkingError() async throws {
        // Given
        mockUserRepository.userStubs = networkingErrorResult

        // When/Then
        await #expect(throws: UserRepositoryError.networking(NSError(domain: "test", code: 0))) {
            try await sut.execute(batchSize: batchSize, page: page)
        }
    }
}

