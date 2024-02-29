//
//  AdventurerModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 16.02.24.
//

import Foundation

struct Adventurer: Codable, Identifiable, Hashable {
    var id: Int
    var username: String
    var email: String
    var password: String
    var profilephoto: String?
    var attendedAdventureIds: [Int]
    var wishlistAdventureIds: [Int]
    var connectedAdventurers: [Int]
}

struct AdventurerDtoRes: Decodable {
    let id: Int
    let username: String
    let email: String
    let attendedAdventureIds: [Int]
    let wishlistAdventureIds: [Int]
}

struct AdventurerDto: Codable {
    let username: String
    let email: String
    let password: String
    var profilephoto: String?

    init(username: String, email: String, password: String, profilephoto: String? = nil) {
        self.username = username
        self.email = email
        self.password = password
        self.profilephoto = profilephoto
    }
}


