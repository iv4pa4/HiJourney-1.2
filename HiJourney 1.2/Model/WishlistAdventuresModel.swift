//
//  WishlistAdventuresModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 16.02.24.
//

import Foundation


struct WishlistModel{
    var wishlist: [WishlistItem] = []
    
    func addToWishlist(adventurerId: Int, adventureId: Int) {
        guard let url = URL(string: "http://localhost:3001/adventurer/\(adventurerId)/add-to-wishlist/\(adventureId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let jwtToken = getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully:", jwtToken)
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
    }
}
