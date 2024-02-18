import SwiftUI

struct WishlistAdventuresDisplayView: View {
    @State private var adventurerId: Int = currentAdventurer.id// Set the default adventurer ID
    @State private var wishlistAdventures: [WishlistItem2] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                    ForEach(wishlistAdventures) { adventure in
                        NavigationLink(destination: DetailedWishlistViewScreen(wishlistAdventure: adventure)) {
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
            fetchWishlistData()
        }
    }
    
    private func fetchWishlistData(){
        guard let url = URL(string: "http://localhost:3001/adventurer/\(currentAdventurer.id)/wishlist") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add JWT token to the Authorization header
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON response: \(jsonString)")
            }
            
            do {
                let result = try JSONDecoder().decode([WishlistItem2].self, from: data)
                DispatchQueue.main.async {
                    self.wishlistAdventures = result // Use self.wishlist to access the property
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}


#Preview {
    WishlistAdventuresDisplayView()
}
