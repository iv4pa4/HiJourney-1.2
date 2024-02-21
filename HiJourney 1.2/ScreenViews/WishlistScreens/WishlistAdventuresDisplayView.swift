import SwiftUI

struct WishlistAdventuresDisplayView: View {
    @State private var adventurerId: Int = currentAdventurer.id// Set the default adventurer ID
    //@State private var wishlistAdventures: [WishlistItem] = []
    @ObservedObject var adventurerProps : AdventurerViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach(adventurerProps.wishlistAdventuresFetched) { adventure in
                        NavigationLink(destination: DetailedAdventureWishlistViewPage(adventure: adventure, viewModel: Connection())) {
                            VStack {
                                DetailedWishlistViewScreen(wishlistAdventure: adventure)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Wishlist")
        }
        .onAppear {
            // Fetch wishlist adventures when the view appears
            adventurerProps.fetchWishlistData()
        }
    }
    


}


#Preview {
    WishlistAdventuresDisplayView(adventurerProps: AdventurerViewModel())
}
