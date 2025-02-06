import SwiftUI

struct DemographicSection: View {
    let user: User
    let vSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: vSpacing) {
            Text("Demographic Information")
                .font(.title)
            ContactRow(label: "Gender", value: user.gender, icon: "person.fill")
            ContactRow(label: "Nationality", value: user.nationality, icon: "globe")
        }
    }
}

#Preview {
    DemographicSection(
        user: User.randomMock(),
        vSpacing: 10
    )
}
