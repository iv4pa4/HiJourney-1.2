//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit


var currentAdventurer: Adventurer = Adventurer(id: 34, username: "String", email: "String", password: "String", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: [])




struct AdventureModelLogic {
    var wishlist: [WishlistItem] = [] 
    
    
    func setCurrentAdventurer(){}
    func createCurrentAdventurer(){
    }
    
    func createNewAdventure(name: String, description: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3001/adventure") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Using currentAdventurer as the only element in the creators array
        let body: [String: AnyHashable] = [
            "name": name,
            "description": description,
            "creators": [currentAdventurer]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // Parse the response to create a new 'Adventure' object
                        if let id = jsonResponse["id"] as? Int,
                           let name = jsonResponse["name"] as? String,
                           let description = jsonResponse["description"] as? String,
                           let creator = jsonResponse["creatorName"] as? String {
                            let newAdventure = Adventure(id: id, name: name, description: description, creatorName :creator)
                            // Handle the new adventure object
                            //handleNewAdventure(newAdventure)
                            completion(true)
                        } else {
                            print("Error: Invalid data format")
                            completion(false)
                        }
                    } else {
                        print("Error: Unable to parse JSON response")
                        completion(false)
                    }
                } catch {
                    print("Error: \(error)")
                    completion(false)
                }
            } else {
                print("Error: \(error as Any)")
                completion(false)
            }
        }
        task.resume()
    }
    
    func createUser(username: String, email: String, password: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
        let adventurerDto = AdventurerDto(username: username, email: email, password: password)
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(adventurerDto)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        // Decode the response data to get the created adventurer
                        let adventurer = try JSONDecoder().decode(Adventurer.self, from: data)
                        // Update the currentAdventurer variable
                        currentAdventurer.id = adventurer.id
                        currentAdventurer.username = adventurer.username
                        currentAdventurer.email = adventurer.email
                        currentAdventurer.password = adventurer.password
                        
                        completion(.success(adventurer))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    
}





