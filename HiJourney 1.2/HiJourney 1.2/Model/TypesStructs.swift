//
//  TypesStructs.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 20.01.24.
//

import SwiftUI

struct Creator: Codable {
    var id: Int
    var username: String
    var email: String
    var password: String
    var createdAdventures: [Int]
}


struct Adventure: Identifiable, Decodable {
    var id: Int
    var name: String
    var description: String
    var creatorName: String
}


struct Adventurer: Codable, Identifiable, Hashable {
    var id: Int
    var username: String
    var email: String
    var password: String
    var attendedAdventureIds: [Int]
    var wishlistAdventureIds: [Int]
    var connectedAdventurers: [Int]
    
}

struct AdventurerResponse: Codable {
    var items: [Adventurer]
}

struct AdventurerDto: Codable {
    let username: String
    let email: String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}

