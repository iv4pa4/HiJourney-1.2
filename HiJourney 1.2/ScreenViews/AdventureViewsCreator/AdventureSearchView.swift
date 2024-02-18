//
//  AdventureSearchView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 16.02.24.
//

import SwiftUI


struct AdventureSearchView: View {
    @State private var searchInput = ""
    @State private var adventures: [Adventure] = []
    
    func searchAdventures() {
        let searchTerms = searchInput.split(separator: " ").map { String($0) }
        
        guard !searchTerms.isEmpty else {
            print("Please enter at least one search term")
            return
        }
        
        let queryItems = searchTerms.map { URLQueryItem(name: "keyword", value: $0) }
        var urlComponents = URLComponents(string: "http://localhost:3001/search/description")!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Failed to construct URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([Adventure].self, from: data) {
                DispatchQueue.main.async {
                    self.adventures = decodedResponse
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            TextField("Search Adventure by Description", text: $searchInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search Adventures") {
                searchAdventures()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            List(adventures, id: \.id) { adventure in
                VStack(alignment: .leading) {
                    Text("Name: \(adventure.name)")
                    Text("Description: \(adventure.description)")
                    Text("Creator: \(adventure.creatorName)")
                }
            }
        }
        .padding()
    }
}


#Preview {
    AdventureSearchView()
}
