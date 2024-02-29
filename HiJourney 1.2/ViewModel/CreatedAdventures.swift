//
//  CreatedAdventures.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 19.02.24.
//

import SwiftUI

class AttendedAdventuresViewModel: ObservableObject {
    @Published var adventures: [Adventure] = []
    var userSession = UserSession()
    
    func fetchAdventures() {
            guard let url = URL(string: "\(urlForAdventurer)/\(currentCreator.id)/attended-adventures") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode([Adventure].self, from: data)
                    DispatchQueue.main.async {
                        self.adventures = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }.resume()
    }
}
