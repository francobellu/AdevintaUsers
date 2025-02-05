@testable import AdevintaUsers
import Foundation

extension User {
    static let defaultLocation = Location(
        street: Street(number: 123, name: "Test Street"),
        city: "TestCity",
        state: "TestState",
        country: "TestCountry",
        postcode: "12345",
        coordinates: Coordinates(latitude: "0", longitude: "0"),
        timezone: Timezone(offset: "+0:00", description: "Test/Timezone")
    )
    static let defaultDateInfo = DateInfo(date: Date(), age: 30)
    static let defaultPicture = Picture(
        large: "https://example.com/large.jpg",
        medium: "https://example.com/medium.jpg",
        thumbnail: "https://example.com/thumbnail.jpg"
    )

    // Base user stub with default picture
    static func userJohnDoe() -> User {
        User(
            gender: "male",
            name: Name(title: "Mr", first: "John", last: "Doe"),
            location: Self.defaultLocation,
            email: "john@example.com",
            login: Login(
                uuid: "111",
                username: "johndoe",
                password: "pass123",
                salt: "salt123",
                md5: "md5hash",
                sha1: "sha1hash",
                sha256: "sha256hash"
            ),
            dob: Self.defaultDateInfo,
            registered: Self.defaultDateInfo,
            phone: "12",
            cell: "1234",
            userId: UserId(name: "John", value: "AAA"),
            picture: Self.defaultPicture,
            nationality: "American",
            isBlacklisted: false
        )
    }

    static func userJohnDoe_differentId() -> User {
        User(
            gender: "male",
            name: Name(title: "Mr", first: "John", last: "Doe"),
            location: Self.defaultLocation,
            email: "john@example.com",
            login: Login(
                uuid: "112",
                username: "johndoe",
                password: "pass123",
                salt: "salt123",
                md5: "md5hash",
                sha1: "sha1hash",
                sha256: "sha256hash"
            ),
            dob: Self.defaultDateInfo,
            registered: Self.defaultDateInfo,
            phone: "12",
            cell: "1234",
            userId: UserId(name: "John", value: "BBB"),
            picture: Self.defaultPicture,
            nationality: "American",
            isBlacklisted: false
        )
    }

    static func userJohnDoe_differentName() -> User {
        User(
            gender: "male",
            name: Name(title: "Mr", first: "John", last: "Smith"),
            location: Self.defaultLocation,
            email: "john@example.com",
            login: Login(
                uuid: "111",
                username: "johndoe",
                password: "pass123",
                salt: "salt123",
                md5: "md5hash",
                sha1: "sha1hash",
                sha256: "sha256hash"
            ),
            dob: Self.defaultDateInfo,
            registered: Self.defaultDateInfo,
            phone: "12",
            cell: "1234",
            userId: UserId(name: "John", value: "AAA"),
            picture: Self.defaultPicture,
            nationality: "American",
            isBlacklisted: false
        )
    }

    static func userJohnDoe_differentEmail() -> User {
        User(
            gender: "male",
            name: Name(title: "Mr", first: "John", last: "Doe"),
            location: Self.defaultLocation,
            email: "johnAA@example.com",
            login: Login(
                uuid: "111",
                username: "johndoe",
                password: "pass123",
                salt: "salt123",
                md5: "md5hash",
                sha1: "sha1hash",
                sha256: "sha256hash"
            ),
            dob: Self.defaultDateInfo,
            registered: Self.defaultDateInfo,
            phone: "12",
            cell: "1234",
            userId: UserId(name: "John", value: "AAA"),
            picture: Self.defaultPicture,
            nationality: "American",
            isBlacklisted: false
        )
    }

    static func userJohnDoe_differentTel() -> User {
        User(
            gender: "male",
            name: Name(title: "Mr", first: "John", last: "Doe"),
            location: Self.defaultLocation,
            email: "john@example.com",
            login: Login(
                uuid: "111",
                username: "johndoe",
                password: "pass123",
                salt: "salt123",
                md5: "md5hash",
                sha1: "sha1hash",
                sha256: "sha256hash"
            ),
            dob: Self.defaultDateInfo,
            registered: Self.defaultDateInfo,
            phone: "99",
            cell: "4321",
            userId: UserId(name: "John", value: "AAA"),
            picture: Self.defaultPicture,
            nationality: "American",
            isBlacklisted: false
        )
    }
}
