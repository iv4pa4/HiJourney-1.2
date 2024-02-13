//
//  TestAddingFavAdventure.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 13.02.24.
//

import SwiftUI


struct TestAddToWishlistView: View {
    var body: some View {
        Button("Add to Wishlist") {
            addToWishlist(adventurerId: 80, adventureId: 13) // Replace with actual adventurerId and adventureId
        }
        .padding()
    }
}

func addToWishlist(adventurerId: Int, adventureId: Int) {
    guard let url = URL(string: "http://localhost:3001/adventurer/\(adventurerId)/add-to-wishlist/\(adventureId)") else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Add JWT token to the Authorization header
    request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON response: \(jsonString)")
            print("Successful")
        }
        
    }.resume()
}



#Preview {
    TestAddToWishlistView()
}
