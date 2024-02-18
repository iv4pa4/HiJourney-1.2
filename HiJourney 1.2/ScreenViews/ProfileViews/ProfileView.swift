import SwiftUI

struct ProfileView: View {
    let adventurer: Adventurer
    @ObservedObject var attendedAdventuresVM = AttendedAdventuresVModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack {
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 50)

                Text(adventurer.username)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                NavigationLink(destination: ConnectedAdventurersDisplayView()) {
                    Text("View Connected Adventurers")
                }
                
                if attendedAdventuresVM.attendedAdventures.isEmpty {
                    Text("Not attended yet")
                        .font(.title2)
                        .padding(.top, 20)
                } else {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(attendedAdventuresVM.attendedAdventures, id: \.id) { adventure in
                            Text(adventure.name) // Display attended adventure name
                        }
                    }
                    .padding(.top, 20)
                }

                Spacer()
            }
            .onAppear {
                // Fetch attended adventures when the view appears
                attendedAdventuresVM.getAttendedAdventures(adventurerId: adventurer.id)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(adventurer: Adventurer(id: 78, username: "test", email: "", password: "", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: []))
    }
}
