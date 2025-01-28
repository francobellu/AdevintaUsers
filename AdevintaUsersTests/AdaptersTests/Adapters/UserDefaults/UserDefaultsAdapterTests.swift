import Foundation
import Testing
@testable import AdevintaUsers

@Suite("UserDefaultsAdapter Tests", .serialized)
struct UserDefaultsAdapterTests {
    var sut: UserDefaultsAdapter!
    var defaults: UserDefaults!
    // Test constants
    let testUsers: [User]
    var testUsersDTOs: [UserDTO]

    init() {
        testUsers =  User.randomMocks(num: 2)
        testUsersDTOs = testUsers.map(UserDTO.init)

    }


    // Test saving and retrieving users
    @Test("Save and retrieve users successfully")
    mutating func test_saveAndRetrieveUsers_shouldReturnSavedUsers() throws {
        // Given
        defaults = UserDefaults(suiteName: #function)!
        sut = UserDefaultsAdapter(defaults: defaults)

        // When
        sut.save(testUsersDTOs, for: .uniqueUsers)
        let retrievedUsersDTOs = sut.getUsers(for: .uniqueUsers)

        // Then
        let retrievedUsers: [User] = retrievedUsersDTOs.map{$0.toDomain()}
        #expect(retrievedUsers == testUsers)

        // Cleanup
        defaults.removePersistentDomain(forName: #function)
    }

    @Test("Retrieve empty array when no users saved")
    mutating func test_retrieveUsers_whenNoUsersSaved_shouldReturnEmptyArray() throws {
        // Given
        defaults = UserDefaults(suiteName: #function)!
        sut = UserDefaultsAdapter(defaults: defaults)

        // When
        let retrievedUsers = sut.getUsers(for: .uniqueUsers)
        
        // Then
        #expect(retrievedUsers.isEmpty)

        // Cleanup
        defaults.removePersistentDomain(forName: #function)
    }
    
    @Test("Save users for different keys")
    mutating func test_saveUsersForDifferentKeys_shouldNotOverwrite() throws {
        // Given
        defaults = UserDefaults(suiteName: #function)!
        sut = UserDefaultsAdapter(defaults: defaults)

        // When
        sut.save([testUsersDTOs[0]], for: .uniqueUsers)
        sut.save([testUsersDTOs[1]], for: .blacklistedUsers)

        let retrievedUsersDTOs = sut.getUsers(for: .uniqueUsers)
        let retrievedBlacklistedDTOs = sut.getUsers(for: .blacklistedUsers)

        // Then
        let retrievedUsers: [User] = retrievedUsersDTOs.map{$0.toDomain()}
        #expect(retrievedUsers == [testUsers[0]])

        let retrievedBlacklisted: [User] = retrievedBlacklistedDTOs.map{$0.toDomain()}
        #expect(retrievedBlacklisted == [testUsers[1]])

        // Cleanup
        defaults.removePersistentDomain(forName: #function)
    }

    @Test(
        "Initialize with existing data",
        arguments: [
            UserDefaultsAdapter.Key.uniqueUsers,
            UserDefaultsAdapter.Key.blacklistedUsers
        ]
    )

    mutating func test_initialize_withExistingData_shouldLoadData_( userDefaultKey: UserDefaultsAdapter.Key) throws {
        // Given
        defaults = UserDefaults(suiteName: #function)!
        sut = UserDefaultsAdapter(defaults: defaults)

        // Pre-populate UserDefaults with data
        let encodedUsers = try JSONEncoder().encode(testUsersDTOs)
        defaults.set(encodedUsers, forKey: userDefaultKey.rawValue)

        // When
        let sut = UserDefaultsAdapter(defaults: defaults)

        // Then
        let loadedUsersDTO = sut.getUsers(for: userDefaultKey)

        let loadedUsers: [User] = loadedUsersDTO.map{$0.toDomain()}
        #expect(loadedUsers == testUsers)
        // Cleanup
        defaults.removePersistentDomain(forName: #function)
    }
    
}

