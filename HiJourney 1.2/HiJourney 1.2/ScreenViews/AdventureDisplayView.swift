import SwiftUI

struct AdventureDisplayView: View {

    @ObservedObject var adventureFetcher = AdventureFetcher()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(adventureFetcher.adventures) { adventure in
                        NavigationLink(destination: DetailedAdventureView(adventure: adventure)) {
                            AdventureView(title: adventure.name, adventurePhoto: "rafting", profilePhoto: "profilePic")
                        }
                    }
                }
                .padding()
                .onAppear {
                    adventureFetcher.fetchData()
                }
            }
            .navigationBarTitle("Adventures")
        }
    }
}

// Preview
#Preview {
    AdventureDisplayView()
}

