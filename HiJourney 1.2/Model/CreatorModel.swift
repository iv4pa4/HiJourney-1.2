//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit


var currentAdventurer: Adventurer = Adventurer(id: 78, username: "iva", email: "String", password: "String", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: [])
var currentCreator: Creator = Creator(id: 34, username: "String", email: "String", password: "String",  createdAdventures: [])
var jwtToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InlAZ21haWwuY29tIiwiaWF0IjoxNzA4MDk1NTE0LCJleHAiOjE3MDgwOTkxMTR9.C6lnhuDWRvqhLxagPXwxJDsTpe0G8ru21kdTQlRLVsM"



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
    
    
    
    
    
    mutating func createCreator(username: String, email: String, password: String, validateUser: @escaping (String, String, @escaping (Result<String, Error>) -> Void) -> Void, completion: @escaping (Result<Creator, Error>) -> Void) {
        let creatorDto = CreatorDto(username: username, email: email, password: password)
        guard let url = URL(string: "http://localhost:3001/creator") else {
            let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(creatorDto)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let creator = try JSONDecoder().decode(Creator.self, from: data)
                        validateUser(email, password) { result in
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
    
    
    
   
    
    
//    func validateCreator(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let url = URL(string: "http://localhost:3001/creator/validate") else {
//            print("Invalid URL")
//            return
//        }
//        
//        let body: [String: String] = ["email": email, "password": password]
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: body)
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    completion(.failure(error ?? NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
//                    return
//                }
//                
//                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//                    do {
//                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                           let token = json["token"] as? String {
//                            jwtToken = token
//                            completion(.success(token))
//                        } else {
//                            let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid token response"])
//                            completion(.failure(error))
//                        }
//                    } catch {
//                        completion(.failure(error))
//                    }
//                } else {
//                    let error = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
//                    completion(.failure(error))
//                }
//            }.resume()
//        } catch {
//            completion(.failure(error))
//        }
//    }
    
    func validateCreator(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = "http://localhost:3001/creator/validate"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters = ["email": email, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchCreatorByEmail(email: String, completion: @escaping (Result<CreatorDTORes, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3001/creator/email/\(email)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let creator = try decoder.decode(CreatorDTORes.self, from: data)
                    completion(.success(creator))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    
}
