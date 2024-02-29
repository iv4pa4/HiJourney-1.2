import SwiftUI




struct AdventurerDisplayView: View {
    @ObservedObject var viewModel : AdventurerViewModel
    @ObservedObject var viewModelCon : Connection
    @ObservedObject var userSession : UserSession
    @State private var selectedAdventurer: Adventurer?
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.adventurers, id: \.id) { adventurer in
                        Button(action: {
                            self.selectedAdventurer = adventurer
                        }) {
                            AdventurerDetailedView(adventurer: adventurer)
                                .background(Color.gray.opacity(0.2)) // Optional styling
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationBarTitle("Meet")
            .sheet(item: $selectedAdventurer) { adventurer in
                DetailedAdventurerViewProfile(adventurer: adventurer, viewModel: viewModelCon, userSession: userSession, attendedModel: AttendedAdventuresVModel())
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }
}


#Preview {
    AdventurerDisplayView(viewModel: AdventurerViewModel(), viewModelCon: Connection(), userSession: UserSession() )
}

