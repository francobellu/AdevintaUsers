import SwiftUI

struct ContactInformationSection: View {
    let user: User
    let vSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading,spacing: vSpacing) {
            Text("Contact Information")
            .font(.title)
            ContactRow(label: "Username", value: user.login.username, icon: "person.circle")
            ContactRow(label: "Email", value: user.email, icon: "envelope")
            ContactRow(label: "Phone", value: user.phone, icon: "phone")
            ContactRow(label: "Cell", value: user.cell, icon: "iphone")
        }
    }
}
#Preview {
    ContactInformationSection(
        user: User.randomMock(),
        vSpacing: 16
    )
}
