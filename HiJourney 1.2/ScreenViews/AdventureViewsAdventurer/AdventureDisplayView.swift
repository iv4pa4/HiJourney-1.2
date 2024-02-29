import SwiftUI

struct AdventureDisplayView: View {

    @StateObject var adventureFetcher = AdventureFetcher()
    @StateObject var viewModel: Connection
    @State private var isPresentingSearchView = false 
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(adventureFetcher.adventures) { adventure in
                        NavigationLink(destination: DetailedAdventureView(adventure: adventure, viewModel: viewModel, viewModelAdv: AttendedAdventuresVModel())) {
                            AdventureView(adventure: adventure)
                        }
                    }
                }
                .padding()
                .onAppear {
                    adventureFetcher.fetchData()
                }
            }
            .navigationBarTitle("Adventures")
//            .navigationBarItems(trailing:
//                
//            NavigationLink("🔎", destination: AdventureSearchView(adventureProps: adventureFetcher))
//                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//
//                                
//            )
            
        }
    }
}

// Preview
struct AdventureDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureDisplayView(viewModel: Connection())
    }
}
