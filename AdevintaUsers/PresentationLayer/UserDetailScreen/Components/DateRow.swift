import SwiftUI

struct DateRow: View {
    let label: String
    let dateInfo: DateInfo

    var body: some View {
        HStack {
            let formattedDate = DateFormatter.localizedString(from: dateInfo.date, dateStyle: .medium, timeStyle: .none)
            let age = dateInfo.age
            Text("\(label): \(formattedDate) (\(age) years old)")
                .font(.callout)
            Spacer()
        }
    }
}

#Preview {
    let label = "Birthdate"
    let date = DateInfo(
        date: Date(),
        age: 30
    )
    DateRow(
        label: label,
        dateInfo: date
    )
}
