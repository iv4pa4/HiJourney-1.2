//
//  Connection.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

protocol ConnectionProtocol: ObservableObject{
    //func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    //func signInCreator(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    //func getAdventurerByEmail(email: String, token: String)
    //func attendAdventures(adventurerId: Int, adventureId: Int)
    func fetchWishlistData()
    //func createUserAdventurer(username: String, email: String, password: String, profilephoto: String, completion: @escaping (Result<Adventurer, Error>) -> Void)
    //func createUserCreator(username: String, email: String, password: String, completion: @escaping (Result<Creator, Error>) -> Void)
    //func addToWishlist(adventurerId: Int, adventureId: Int)
    //func connectAdventurers(adventurerId1: Int, adventurerId2: Int, token: String)
    //func getSignedStatus() -> Bool
    
}

class Connection: ObservableObject, ConnectionProtocol{
    @Published private var model = CreatorModel()
    @Published private var modelA = AdventurerViewModel()
    @Published private var modelW = WishlistModel()
    @Published var adventures: [Adventure] = []
    @Published var wishlist: [WishlistItem] = []
    var userSession = UserSession()
    var isSignedIn = false
    init() {
        // fetchData()
        //fetchWishlistData()
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        modelA.signIn(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error)) 
            }
        }
    }
    
    func signInCreator(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        model.signInCreator(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func getAdventurerByEmail(email: String, token: String) {
        modelA.getAdventurerByEmail(email: email, token: token) { result in
            switch result {
            case .success(let adventurer):
                currentAdventurer = adventurer

                print("Successful login")
            case .failure(let error):
                print("Failed to fetch adventurer: \(error)")
            }
        }
    }



    func attendAdventures(adventurerId: Int, adventureId: Int){
        modelA.attendAdventure(adventurerId: adventurerId, adventureId: adventureId)
    }
    
    func fetchWishlistData(){
        guard let url = URL(string: "\(urlForAdventurer)/\(currentAdventurer.id)/wishlist") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                }
                
                do {
                    let result = try JSONDecoder().decode([WishlistItem].self, from: data)
                    DispatchQueue.main.async {
                        self.wishlist = result 
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

    func createUserAdventurer(username: String, email: String, password: String, profilephoto: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
        modelA.createUserAdventurer(username: username, email: email, password: password, profilephoto: profilephoto, validateUser: modelA.validateUser) { result in
                switch result {
                case .success(let adventurer):
                    AdventurerSaver.saveAdventurer(adventurer)
                    currentAdventurer = adventurer
                    self.fetchWishlistData()
                    completion(.success(adventurer))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func createUserCreator(username: String, email: String, password: String, completion: @escaping (Result<Creator, Error>) -> Void) {
        model.createUserCreator(username: username, email: email, password: password, validateUserCreator: model.validateUserCreator) { result in
                switch result {
                case .success(let creator):
                    currentCreator = creator
                    completion(.success(creator))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    func addToWishlist(adventurerId: Int, adventureId: Int){
        modelW.addToWishlist(adventurerId: adventurerId, adventureId: adventureId)
    }
    
    func connectAdventurers(adventurerId1: Int, adventurerId2: Int, token: String){
        modelA.connectAdventurers(adventurerId1: adventurerId1, adventurerId2: adventurerId2, token: token)
    }

    func getSignedStatus() -> Bool {
        return self.isSignedIn
    }

    
}


