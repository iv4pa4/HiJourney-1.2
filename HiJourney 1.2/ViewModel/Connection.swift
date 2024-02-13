//
//  Connection.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

class Connection: ObservableObject {
    @Published private var model = AdventureModelLogic()
    @Published var adventures: [Adventure] = []
    @Published var wishlist: [WishlistItem2] = []
    init() {
        // fetchData()
        //fetchWishlistData()
    }
    
    func signIn() {
        
    }
    
    
//    func createUser(username: String, email: String, password: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
//        // Call the createUser function from the model
//        model.createUser(username: username, email: email, password: password) { result in
//            switch result {
//            case .success(let adventurer):
//                currentAdventurer = adventurer
//                self.fetchWishlistData()
//                completion(.success(adventurer))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    
    
    //    func createNewAdventure(name: String, description: String, completion: @escaping (Bool) -> Void){
    //        model.createNewAdventure(name: name, description: description, completion: completion)
    //    }
    
    func setCurrentAdventurer(){
        model.setCurrentAdventurer()
    }
    
    func createCurrentAdventurer(){
        model.createCurrentAdventurer()
    }
    
    
    func fetchWishlistData(){
            guard let url = URL(string: "http://localhost:3001/adventurer/\(currentAdventurer.id)/wishlist") else {
                return
            }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON response: \(jsonString)")
                }

                do {
                    let result = try JSONDecoder().decode([WishlistItem2].self, from: data)
                    DispatchQueue.main.async {
                        self.wishlist = result // Use self.wishlist to access the property
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

    func createUser(username: String, email: String, password: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
            model.createUser(username: username, email: email, password: password, validateUser: model.validateUser) { result in
                switch result {
                case .success(let adventurer):
                    // Update currentAdventurer
                    currentAdventurer = adventurer
                    // Fetch wishlist data
                    // Assuming fetchWishlistData is a method of your view model
                    self.fetchWishlistData()
                    // Call completion with success
                    completion(.success(adventurer))
                case .failure(let error):
                    // Call completion with failure
                    completion(.failure(error))
                }
            }
        }

    func addToWishlist(adventurerId: Int, adventureId: Int){
        model.addToWishlist(adventurerId: adventurerId, adventureId: adventureId)
    }
    
}


