//
//  AttendedAdventuresVModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 14.02.24.
//

import SwiftUI


class AttendedAdventuresVModel: ObservableObject {
    @Published var attendedAdventures: [AdventureRes] = []
    
    func getAttendedAdventures(adventurerId: Int) {
        let urlString = "http://localhost:3001/adventurer/\(adventurerId)/attended-adventures"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Ensure there is data
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode the received data into an array of Adventure objects
                let decoder = JSONDecoder()
                let attendedAdventures = try decoder.decode([AdventureRes].self, from: data)
                
                // Update attendedAdventures with the fetched data
                DispatchQueue.main.async {
                    self.attendedAdventures = attendedAdventures
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func getCurrAttendedAdventures() {
        // Construct the URL with the adventurerId
        let urlString = "http://localhost:3001/adventurer/\(currentAdventurer.id)/attended-adventures"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest with the URL
        var request = URLRequest(url: url)
        
        // Set the HTTP method to GET
        request.httpMethod = "GET"
        
        // Perform the data task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Ensure there is data
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode the received data into an array of Adventure objects
                let decoder = JSONDecoder()
                let attendedAdventures = try decoder.decode([AdventureRes].self, from: data)
                
                // Update attendedAdventures with the fetched data
                DispatchQueue.main.async {
                    self.attendedAdventures = attendedAdventures
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

