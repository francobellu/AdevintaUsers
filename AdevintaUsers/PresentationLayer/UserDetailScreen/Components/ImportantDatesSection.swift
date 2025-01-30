import SwiftUI

struct ImportantDatesSection: View {
    let user: User
    let vSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: vSpacing) {
            Text("Important Dates")
            .font(.title)

            DateRow(label: "Date of Birth", dateInfo: user.dob)
            DateRow(label: "Registered", dateInfo: user.registered)
        }
    }
}
