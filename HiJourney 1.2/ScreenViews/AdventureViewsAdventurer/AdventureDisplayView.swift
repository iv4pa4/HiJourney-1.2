import SwiftUI

struct AdventureDisplayView: View {

    @ObservedObject var adventureFetcher = AdventureFetcher()
    @ObservedObject var viewModel: Connection
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
            .navigationBarItems(trailing:
                Button(action: {
                    isPresentingSearchView.toggle()
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .padding(.top, 80)
                }
                .sheet(isPresented: $isPresentingSearchView) {
                    AdventureSearchView(adventureProps: AdventureFetcher())
                }
                                
            )
        }
    }
}

// Preview
struct AdventureDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureDisplayView(viewModel: Connection())
    }
}
