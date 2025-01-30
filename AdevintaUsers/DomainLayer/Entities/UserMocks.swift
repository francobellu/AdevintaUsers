import SwiftUI

#if DEBUG

// MARK: Mocks
extension User {
    static func randomMock() -> User {
        let genders = ["male", "female"]
        let titles = ["Mr.", "Mrs.", "Ms.", "Dr."]
        let firstNames = ["John", "Jane", "Mike", "Sarah", "David", "Emma", "Tom", "Lucy"]
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis"]
        let phones = ["+1234567890", "+1987654321", "+1472583690", "+1589632470"]
        let cells = ["+1357924680", "+11234567890", "+1987654320", "+1472583012"]
        let nationalities = ["US", "GB", "AU", "CA"]
        let pictures = [
            "https://randomuser.me/api/portraits/men/1.jpg",
            "https://randomuser.me/api/portraits/women/1.jpg",
            "https://randomuser.me/api/portraits/men/2.jpg",
            "https://randomuser.me/api/portraits/women/2.jpg"
        ]

        let firstName = firstNames.randomElement() ?? "User"
        let lastName = lastNames.randomElement() ?? "Test"

        let location = Location(
            street: Street(number: Int.random(in: 1...9999), name: "Main St"),
            city: "Anytown",
            state: "State",
            country: "Country",
            postcode: "12345",
            coordinates: Coordinates(latitude: "0.0", longitude: "0.0"),
            timezone: Timezone(offset: "+0:00", description: "UTC")
        )

        let login = Login(
            uuid: UUID().uuidString,
            username: "user_\(firstName.lowercased())",
            password: "password",
            salt: "mock_salt",  
            md5: UUID().uuidString,  
            sha1: UUID().uuidString,  
            sha256: UUID().uuidString  
        )

        let dob = DateInfo(date: Date(), age: Int.random(in: 18...90))
        let registered = DateInfo(date: Date(), age: Int.random(in: 1...10))

        let picture = Picture(
            large: pictures.randomElement() ?? "",
            medium: pictures.randomElement() ?? "",
            thumbnail: pictures.randomElement() ?? ""
        )

        let user = User(
            gender: genders.randomElement() ?? "male",
            name: Name(
                title: titles.randomElement() ?? "Mr.",
                first: firstName,
                last: lastName
            ),
            location: location,
            email: "\(firstName.lowercased()).\(lastName.lowercased())@example.com",
            login: login,
            dob: dob,
            registered: registered,
            phone: phones.randomElement() ?? "+0000000000",
            cell: cells.randomElement() ?? "+0000000000",
            userId: UserId(
                name: "\(firstName)\(lastName)",
                value: UUID().uuidString
            ),
            picture: picture,
            nationality: nationalities.randomElement() ?? "US"
        )
        return user
    }

    static func randomMocks(num: Int) -> [User] {
        var result: [User] = []
        for _ in 0..<num {
            let user = User.randomMock()
            result.append(user)
        }
        return result
    }

}
#endif


import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Profile Picture and Name
                VStack {
                    if let url = URL(string: user.picture.large) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } placeholder: {
                            ProgressView()
                        }
                    }

                    Text("\(user.name.title) \(user.name.first) \(user.name.last)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)

                // Contact Information
                Section(header: Text("Contact Information").font(.headline)) {
                    contactRow(label: "Email", value: user.email, icon: "envelope")
                    contactRow(label: "Phone", value: user.phone, icon: "phone")
                    contactRow(label: "Cell", value: user.cell, icon: "iphone")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                // Location
                Section(header: Text("Location").font(.headline)) {
                    Text("\(user.location.street.number) \(user.location.street.name),")
                    Text("\(user.location.city), \(user.location.state),")
                    Text("\(user.location.country) - \(user.location.postcode)")
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)

                // Dates
                Section(header: Text("Important Dates").font(.headline)) {
                    dateRow(label: "Date of Birth", dateInfo: user.dob)
                    dateRow(label: "Registered", dateInfo: user.registered)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }

    private func contactRow(label: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text("\(value)")
        }
        .padding(.vertical, 4)
    }

    private func dateRow(label: String, dateInfo: DateInfo) -> some View {
        HStack {
            let formattedDate = DateFormatter.localizedString(from: dateInfo.date, dateStyle: .medium, timeStyle: .none)
            let age = dateInfo.age
            Text("\(label): \(formattedDate) (\(age) years old)")
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    // Test with a mock user for preview
    UserDetailView(user: User.randomMock())
}
