//
//  AdventureFetcher.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import Foundation

struct AdventureDto : Codable{
   var name: String
   var description: String
}

class AdventureFetcher: ObservableObject {
    @Published var adventures: [Adventure] = []
    @Published var foundAdventures: [SearchAdventure] = []
    var userSession = UserSession()
    
    init() {
        
    }
    
    func fetchData() {
        
        guard let url = URL(string: urlForAdventure) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jwtToken = userSession.getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("Failed to retrieve JWT token.")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let decodedData = try? JSONDecoder().decode([Adventure].self, from: data) {
                        DispatchQueue.main.async {
                            self.adventures = decodedData
                        }
                    } else {
                        print("Failed to decode data")
                    }
                } else {
                    print("HTTP status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    
    func createAdventure(name: String, description: String) {
        let adventureDto = AdventureDto(name: name, description: description)
        guard let jsonData = try? JSONEncoder().encode(adventureDto) else {
            print("Failed to encode adventureDto")
            return
        }
        let url = URL(string: "\(urlForCreator)/\(currentCreator.id)/adventures")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let jwtToken = userSession.getJWTTokenFromKeychain() {
                print("JWT token retrieved successfully")
                
                request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if (200...299).contains(httpResponse.statusCode) {
                            print("Adventure created successfully")
                        } else {
                            print("Error response: \(httpResponse.statusCode)")
                        }
                    }
                }.resume()
        }
    }
    
    func searchAdventureByName(name: String) {
        guard let url = URL(string: "\(urlForAdventure)/search/\(name)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let jwtToken = userSession.getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    return
                }
                
                if let data = data {
                    do {
                        let decodedAdventures = try JSONDecoder().decode([SearchAdventure].self, from: data)
                        DispatchQueue.main.async {
                            self.foundAdventures = decodedAdventures
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
    
    func searchAdventureByDescription(desc: String) {
        guard let url = URL(string: "\(urlForAdventure)/search/description/\(desc)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let jwtToken = userSession.getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    return
                }
                
                if let data = data {
                    do {
                        let decodedAdventures = try JSONDecoder().decode([SearchAdventure].self, from: data)
                        DispatchQueue.main.async {
                            self.foundAdventures = decodedAdventures
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }
    
}
