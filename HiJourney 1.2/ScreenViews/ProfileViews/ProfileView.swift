import SwiftUI

struct ProfileView: View {
    @ObservedObject var userSession : UserSession
    @StateObject var attendedAdventuresVM = AttendedAdventuresVModel()
    
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack {
                Image("c")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 50)

                Text(currentAdventurer.username)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                NavigationLink(destination: ConnectedAdventurersDisplayView(adventurerProps: AdventurerViewModel(), userSession: userSession)) {
                    Text("View Connected Adventurers")
                }
                
                if attendedAdventuresVM.attendedAdventures.isEmpty {
                    Text("Not attended yet")
                        .font(.title2)
                        .padding(.top, 20)
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
            .onAppear {
                attendedAdventuresVM.getAttendedAdventures(adventurerId: currentAdventurer.id)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userSession: UserSession())
    }
}
