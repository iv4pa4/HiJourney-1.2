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
    init() {
       // fetchData()
    }
    //@Published private var databaseMockup = DatabaseMockup()

    func signIn() {
        
    }
   
    
    func createUser(username: String, email: String, password: String, completion: @escaping (Result<Adventurer, Error>) -> Void) {
            // Call the createUser function from the model
            model.createUser(username: username, email: email, password: password) { result in
                switch result {
                case .success(let adventurer):
                    currentAdventurer = adventurer
                    completion(.success(adventurer))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }


    
//    func createNewAdventure(name: String, description: String, completion: @escaping (Bool) -> Void){
//        model.createNewAdventure(name: name, description: description, completion: completion)
//    }
    
    func setCurrentAdventurer(){
        model.setCurrentAdventurer()
    }
    
    func createCurrentAdventurer(){
        model.createCurrentAdventurer()
    }


}

