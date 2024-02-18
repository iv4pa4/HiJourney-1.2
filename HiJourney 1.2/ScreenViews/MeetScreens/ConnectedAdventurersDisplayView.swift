//
//  ContentView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 14.02.24.
//

import SwiftUI
//fix appearance
struct ConnectedAdventurersDisplayView: View {
    let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Ik1pbWlAZ21haWwuY29tIiwiaWF0IjoxNzA3ODY1NDM4LCJleHAiOjE3MDc4NjkwMzh9.65An1_GwdnyVoXEO-oN_6Ox7aAWH5wBysEjdas5q4t4"
    @State private var adventurers = [AdventurerDtoRes]()
    
    var body: some View {
        List(adventurers, id: \.id) { adventurer in
            VStack(alignment: .leading) {
                Text("Adventurer ID: \(adventurer.id)")
                Text("Username: \(adventurer.username)")
                Text("Email: \(adventurer.email)")
                // Display other properties as needed
            }
        }
        .onAppear {
            fetchAdventurers(id: 78)
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
