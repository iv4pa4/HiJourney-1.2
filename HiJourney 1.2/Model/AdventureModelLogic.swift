//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit


var currentAdventurer: Adventurer = Adventurer(id: 34, username: "String", email: "String", password: "String", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: [])
var jwtToken: String = ""



struct AdventureModelLogic {
    var wishlist: [WishlistItem2] = []
    
    
//    mutating func setToken(token: String){
//        self.token = token
//    }
//    mutating func getToken() -> String{
//        self.token
//    }
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
    
    //when creating the user to set the token
    mutating func createUser(username: String, email: String, password: String, validateUser: @escaping (String, String, @escaping (Result<String, Error>) -> Void) -> Void, completion: @escaping (Result<Adventurer, Error>) -> Void) {
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
                                
                                // Call validate function to get JWT token
                                validateUser(email, password) { result in
                                    switch result {
                                    case .success(let token):
                                        // Save token into jwtToken variable
                                        jwtToken = token
                                        // Update the currentAdventurer with other details if needed
                                        currentAdventurer.id = adventurer.id
                                        currentAdventurer.username = adventurer.username
                                        currentAdventurer.email = adventurer.email
                                        currentAdventurer.password = adventurer.password
                                        
                                        completion(.success(adventurer))
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                                }
                                
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    }.resume()
                } catch {
                    completion(.failure(error))
                }
            }

        func validateUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            let parameters = ["email": email, "password": password]
            guard let url = URL(string: "http://localhost:3001/adventurer/validate") else {
                let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(.failure(error))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let data = data {
                        do {
                            guard let token = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                  let jwtToken = token["token"] as? String else {
                                let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token response"])
                                completion(.failure(error))
                                return
                            }
                            completion(.success(jwtToken))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }

    // This function should be added to your AdventurerService class

    func addToWishlist(adventurerId: Int, adventureId: Int) {
        guard let url = URL(string: "http://localhost:3001/adventurer/\(adventurerId)/add-to-wishlist/\(adventureId)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add JWT token to the Authorization header
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
