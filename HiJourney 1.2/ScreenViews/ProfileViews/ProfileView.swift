import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSession: UserSession
    @StateObject var attendedAdventuresVM = AttendedAdventuresVModel()
    @State private var isLogedOut = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button("Logout", action: logout)
                        .padding()
                }
                
                Image("c")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 50)

                Text(currentAdventurer.username)
                    .font(.custom("Poppins-Bold", size:25))
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                NavigationLink(destination: ConnectedAdventurersDisplayView(adventurerProps: AdventurerViewModel(), userSession: userSession)) {
                    Text("View Connected Adventurers")
                }
                
                if attendedAdventuresVM.attendedAdventures.isEmpty {
                    Text("Not attended yet")
                        .font(.custom("Poppins-Bold", size:15))
                        .padding(.top, 20)
                        .foregroundColor(.black)
                } else {
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(attendedAdventuresVM.attendedAdventures, id: \.id) { adventure in
                            NavigationLink(destination: DetailedAttendedAdventureView(adventure: adventure, viewModel: Connection(), viewModelAdv: attendedAdventuresVM)) {
                                AttendedAdventuresView(adventure: adventure)
                            }
                        }
                    }
                    .padding(.top, 20)
                }

                Spacer()
            }
            
            .background(NavigationLink(
                destination: WelcomeScreenView(viewModel: Connection(), creatorProps: CreatorViewModel(), userSession: UserSession()),
                isActive: $isLogedOut,
                label: { EmptyView() }
            ))
            
            .onAppear {
                attendedAdventuresVM.getAttendedAdventures(adventurerId: currentAdventurer.id)
            }
        }
    }

    func logout() {
        AdventurerSaver.deleteAdventurer()
        isLogedOut = true
    }

}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userSession: UserSession())
    }
}
