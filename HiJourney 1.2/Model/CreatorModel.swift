//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit


var currentAdventurer: Adventurer = Adventurer(id: 23, username: "iva", email: "String", password: "String", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: [])
var currentCreator: Creator = Creator(id: 34, username: "String", email: "String", password: "String")
//
var jwtToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpAZ21haWwuY29tIiwiaWF0IjoxNzA4MzM4MjA5LCJleHAiOjE3MDgzNDE4MDl9.5rT3Jk2rUawyxhb-CLucpTEeIGJXwgwMxgxjP-h6HSU"



struct CreatorModel {
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
                            let newAdventure = Adventure(id: id, name: name, description: description, creatorName :creator, photoURL: "")
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
    
    func signInCreator(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        validateUserCreator(email: email, password: password) { result in
            switch result {
            case .success(let token):
                jwtToken = token
                print("Token: \(token)")
                
                self.getCreatorByEmail(email: email, token: token) { result in
                    switch result {
                    case .success(let creator):
                        currentCreator = creator
                        print("Current Creator: \(creator.username)")
                        completion(.success(()))
                    case .failure(let error):
                        print("Error fetching adventurer: \(error)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("Error validating user: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func createUserCreator(username: String, email: String, password: String,  validateUserCreator: @escaping (String, String, @escaping (Result<String, Error>) -> Void) -> Void, completion: @escaping (Result<Creator, Error>) -> Void) {
       let adventurerDto = AdventurerDto(username: username, email: email, password: password)
       guard let url = URL(string: "http://localhost:3001/creator") else {
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
                       let creator = try JSONDecoder().decode(Creator.self, from: data)
                       validateUserCreator(email, password) { result in
                           switch result {
                           case .success(let token):
                               jwtToken = token
                               currentCreator.id = creator.id
                               currentCreator.username = creator.username
                               currentCreator.email = creator.email
                               currentCreator.password = creator.password
                               
                               completion(.success(creator))
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
    
    func validateUserCreator(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters = ["email": email, "password": password]
        guard let url = URL(string: "http://localhost:3001/creator/validate") else {
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
    
    func getCreatorByEmail(email: String, token: String, completion: @escaping (Result<Creator, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3001/creator/email/\(email)") else {
            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                return
            }
            
            do {
                let creator = try JSONDecoder().decode(Creator.self, from: data)
                currentCreator = creator
                print(currentAdventurer.username)
                completion(.success(creator))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    

    
    func authenticate(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3001/adventurer/validate") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: String] = ["email": email, "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                print("Token: \(decodedResponse.token)")
                jwtToken = decodedResponse.token
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    struct TokenResponse: Codable {
        let token: String
    }
    
    
    
}
