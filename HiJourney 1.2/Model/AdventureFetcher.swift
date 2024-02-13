//
//  AdventureFetcher.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import Foundation

class AdventureFetcher: ObservableObject {
    @Published var adventures: [Adventure] = []
    
    func fetchData() {
        guard let url = URL(string: "http://localhost:3001/adventure") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedData = try? JSONDecoder().decode([Adventure].self, from: data) {
                DispatchQueue.main.async {
                    self.adventures = decodedData
                }
            } else {
                print("Failed to decode data")
            }
        }.resume()
    }
}
