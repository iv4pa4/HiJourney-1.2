//
//  ContentView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 14.02.24.
//

import SwiftUI
//fix appearance
struct ConnectedAdventurersDisplayView: View {
    @State private var adventurers = [AdventurerDtoRes]()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(adventurers, id: \.id) {adventurer in
                    VStack(alignment: .leading) {
                        AdventurerDetailedView(adventurer: Adventurer(id: adventurer.id, username: adventurer.username, email: adventurer.email, password: "", attendedAdventureIds: adventurer.attendedAdventureIds, wishlistAdventureIds: adventurer.wishlistAdventureIds, connectedAdventurers: []))
                    }
                }
            }
            .onAppear {
                fetchAdventurers(id: currentAdventurer.id)
            }
            .navigationTitle("Connected adventurers")
        }
    }
    
    func fetchAdventurers(id: Int) {
        let urlString = "http://localhost:3001/adventurer/\(id)/connected-adventurers"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                do {
                    adventurers = try JSONDecoder().decode([AdventurerDtoRes].self, from: data)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}


#Preview {
    ConnectedAdventurersDisplayView()
}
