import SwiftUI

struct LocationInformationSection: View {
    let user: User
    let vSpacing: CGFloat

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: vSpacing) {
                Text("Location")
                .font(.title)
                ContactRow(
                    label: nil, value: "\(user.location.street.number) \(user.location.street.name)\n\(user.location.postcode), \(user.location.city)\n\(user.location.state), \(user.location.country)",
                    icon: "map"
                )
                ContactRow(label: "Timezone", value: user.location.timezone.description, icon: "clock")
                ContactRow(label: "Coordinates", value: "\(user.location.coordinates.latitude), \(user.location.coordinates.longitude)", icon: "mappin")
            }
            Spacer()
        }
    }
}
