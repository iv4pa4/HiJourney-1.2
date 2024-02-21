//
//  AdventurerModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 17.02.24.
//

import SwiftUI

class AdventurerViewModel : ObservableObject {
    @Published var adventurers: [Adventurer] = []
   // @State private var connectedAdventurers = [AdventurerDtoRes]()
    @State var wishlistAdventures: [WishlistItem] = []
    @Published var connectedAdventurers = [AdventurerDtoRes]()
    @Published var wishlistAdventuresFetched: [WishlistItem] = []



    init() {
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            return
        }

        var request = URLRequest(url: url)
        if let jwtToken = getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON response: \(jsonString)")
                }
                
                do {
                    let result = try JSONDecoder().decode([Adventurer].self, from: data)
                    DispatchQueue.main.async {
                        self.adventurers = result
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
    
    
     func createUserAdventurer(username: String, email: String, password: String, profilephoto: String, validateUser: @escaping (String, String, @escaping (Result<String, Error>) -> Void) -> Void, completion: @escaping (Result<Adventurer, Error>) -> Void) {
        let adventurerDto = AdventurerDto(username: username, email: email, password: password, profilephoto: profilephoto)
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
                        let adventurer = try JSONDecoder().decode(Adventurer.self, from: data)
                        validateUser(email, password) { result in
                            switch result {
                            case .success(let token):
                                let saveResult = saveJWTTokenToKeychain(token: token)
                                currentAdventurer.id = adventurer.id
                                currentAdventurer.username = adventurer.username
                                currentAdventurer.email = adventurer.email
                                currentAdventurer.password = adventurer.password
                                currentAdventurer.profilephoto = adventurer.profilephoto
                                
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
    
    func getAdventurerByEmail(email: String, token: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3001/adventurer/email/\(email)") else {
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
                let adventurer = try JSONDecoder().decode(Adventurer.self, from: data)
                currentAdventurer = adventurer
                print(currentAdventurer.username)
                completion(.success(adventurer))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        validateUser(email: email, password: password) { result in
            switch result {
            case .success(let token):
                let saveResult = saveJWTTokenToKeychain(token: token)
                if saveResult {
                    print("JWT token saved successfully!")
                } else {
                    print("Failed to save JWT token.")
                }
                //print("Token: \(token)")
                
                self.getAdventurerByEmail(email: email, token: token) { result in
                    switch result {
                    case .success(let adventurer):
                        currentAdventurer = adventurer
                        print("Current Adventurer: \(adventurer.username)")
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
    
    func connectAdventurers(adventurerId1: Int, adventurerId2: Int, token: String) {
        let urlString = "http://localhost:3001/adventurer/connect/\(adventurerId1)/with/\(adventurerId2)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("Adventurers connected successfully")
            } else {
                print("Failed to connect adventurers. Status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    func attendAdventure(adventurerId: Int, adventureId: Int) {
        let urlString = "http://localhost:3001/adventurer/\(adventurerId)/attend/\(adventureId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let jwtToken = getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully:", jwtToken)
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                print("Adventure attended successfully!")
            }.resume()
        }
    }
    
//    func fetchConnectedAdventurers(id: Int) {
//        let urlString = "http://localhost:3001/adventurer/\(id)/connected-adventurers"
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                print("Invalid response")
//                return
//            }
//            
//            if let data = data {
//                do {
//                    self.connectedAdventurers = try JSONDecoder().decode([AdventurerDtoRes].self, from: data)
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
    
    func fetchAdventurers(id: Int) {
        let urlString = "http://localhost:3001/adventurer/\(id)/connected-adventurers"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let jwtToken = getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                if let data = data {
                    do {
                        self.connectedAdventurers = try JSONDecoder().decode([AdventurerDtoRes].self, from: data)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func fetchWishlistData(){
        guard let url = URL(string: "http://localhost:3001/adventurer/\(currentAdventurer.id)/wishlist") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let jwtToken = getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON response: \(jsonString)")
                }
                
                do {
                    let result = try JSONDecoder().decode([WishlistItem].self, from: data)
                    DispatchQueue.main.async {
                        self.wishlistAdventuresFetched = result
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
    

    
}


