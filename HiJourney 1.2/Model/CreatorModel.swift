//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit
import Security




struct CreatorModel {
    var wishlist: [WishlistItem] = []
    @ObservedObject var userSession = UserSession()
    
    func signInCreator(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        validateUserCreator(email: email, password: password) { result in
            switch result {
            case .success(let token):
                let saveResult = userSession.saveJWTTokenToKeychain(token: token)
                if saveResult {
                    print("JWT token saved successfully!")
                } else {
                    print("Failed to save JWT token.")
                }
                
                self.getCreatorByEmail(email: email, token: token) { result in
                    switch result {
                    case .success(let creator):
                        currentCreator = creator
                        CreatorSaver.saveCreator(creator)
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
       guard let url = URL(string: urlForCreator) else {
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
                               let saveResult = userSession.saveJWTTokenToKeychain(token: token)
                               if saveResult {
                                   print("JWT token saved successfully!")
                               } else {
                                   print("Failed to save JWT token.")
                               }
                               _ = Creator(id: creator.id, username: creator.username, email: creator.email, password: creator.password)
                               currentCreator = creator
                               CreatorSaver.saveCreator(creator)

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
        guard let url = URL(string: "\(urlForCreator)/validate") else {
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
        guard let url = URL(string: "\(urlForCreator)/email/\(email)") else {
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
                CreatorSaver.saveCreator(creator)

                completion(.success(creator))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    

    
    func authenticate(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(urlForAdventurer)/validate") else {
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
                let saveResult = userSession.saveJWTTokenToKeychain(token: decodedResponse.token)
                if saveResult {
                    print("JWT token saved successfully!")
                } else {
                    print("Failed to save JWT token.")
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    struct TokenResponse: Codable {
        let token: String
    }
    
    func createAdventure(eventName: String, eventDescription: String, photoURL: String, completion: @escaping (AdventureFromCreator?) -> Void) {
        let url = URL(string: "\(urlForCreator)/\(currentCreator.id)/adventures")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let jwtToken = userSession.getJWTTokenFromKeychain() {
            
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            let requestBody: [String: Any] = [
                "name": eventName,
                "description": eventDescription,
                "photoURL": photoURL
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300).contains(httpResponse.statusCode) {
                        if let responseData = try? JSONSerialization.jsonObject(with: data, options: []),
                           let json = responseData as? [String: Any],
                           let createdAdventure = try? JSONDecoder().decode(AdventureFromCreator.self, from: data) {
                            completion(createdAdventure)
                        } else {
                            print("Failed to decode created adventure")
                            completion(nil)
                        }
                    } else {
                        print("Failed to create adventure. Status code: \(httpResponse.statusCode)")
                        if let errorMessage = String(data: data, encoding: .utf8) {
                            print("Error message: \(errorMessage)")
                        }
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
        
        
        
    }
}
