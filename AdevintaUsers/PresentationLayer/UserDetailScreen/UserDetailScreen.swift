import SwiftUI

struct UserDetailScreen: View {
    let user: User
    let vSpacing = CGFloat(16)
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProfileHeader(user: user)
                    .padding(16)
                Group {
                    ContactInformationSection(user: user, vSpacing: vSpacing)
                    LoginInformationSection(user: user, vSpacing: vSpacing)
                    DemographicSection(user: user, vSpacing: vSpacing)
                    LocationInformationSection(user: user, vSpacing: vSpacing)
                    ImportantDatesSection(user: user, vSpacing: vSpacing)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .clipped()
            }

            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}






#Preview {
    let user = User.randomMock()
    UserDetailScreen(user: user)
}
