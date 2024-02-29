//
//  AttendedAdventuresVModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 14.02.24.
//

import SwiftUI


class AttendedAdventuresVModel: ObservableObject {
    @Published var attendedAdventures: [AdventureRes] = []
    var userSession = UserSession()
    
    func getAttendedAdventures(adventurerId: Int) {
        let urlString = "\(urlForAdventurer)/\(adventurerId)/attended-adventures"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
               
                let decoder = JSONDecoder()
                let attendedAdventures = try decoder.decode([AdventureRes].self, from: data)
                
                DispatchQueue.main.async {
                    self.attendedAdventures = attendedAdventures
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func getCurrAttendedAdventures(id: Int) {
        // Construct the URL with the adventurerId
            let urlString = "\(urlForAdventurer)/\(id)/attended-adventures"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                   
                    let decoder = JSONDecoder()
                    let attendedAdventures = try decoder.decode([AdventureRes].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.attendedAdventures = attendedAdventures
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
    }
}

