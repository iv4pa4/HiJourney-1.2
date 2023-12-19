//
//  Logic.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import CryptoKit

struct Logic{
    //let advenType = DatabaseMockup()
    var emails : [String] = []
    var adventurers : [Adventurer] = []
    func signIn(){}
    func signUp(){}
    func validateAdventurerData(email: String, password: String){
        if !(email.contains("@")){
            //error
        }
        if containsEmail(email: email){
            //error
        }
        let adventurer = containsAdventurer(email: email)
        if sha256(password) == sha256(adventurer.password){
          //error
        }
        
    }
    
    func containsEmail(email : String)->Bool{
        for adventurer in adventurers {
            if adventurer.email == email{
                return true
            }
        }
        return false
    }
    
    func containsAdventurer(email : String)-> Adventurer{
        for adventurer in adventurers {
            if adventurer.email == email{
                return adventurer
            }
        }
        return Adventurer(id: 0, email: "", password: "", username: "", friends: [], attentedEvents: [])
    }
    
}


func sha256(_ input: String) -> String {
    if let data = input.data(using: .utf8) {
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    } else {
        return ""
    }
}




