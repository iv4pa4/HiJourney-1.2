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
    var createdAdventures: [Adventure]
}

struct Adventure: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var creators: [CreatorSummary]
}

struct CreatorSummary: Codable {
    var id: Int
    var name: String
}

struct Adventurer: Codable, Identifiable {
    var id: Int
    var username: String
    var email: String
    var password: String
    var attendedAdventuresCount: Int
}

struct CreatorDto: Codable {
    var username: String
    var email: String
    var password: String
}

struct CreatorResponseDto: Codable {
    var id: Int
    var username: String
    var email: String

    init(creator: Creator) {
        self.id = creator.id
        self.username = creator.username
        self.email = creator.email
    }
}

struct AdventurerResponse: Codable {
    var items: [Adventurer]
    var meta: MetaData
}


struct MetaAdventure: Codable {
    var totalItems: Int
    var itemCount: Int
    var itemsPerPage: Int
    var totalPages: Int
    var currentPage: Int
}

struct MetaData: Codable {
    var totalItems: Int
    var itemCount: Int
    var itemsPerPage: Int
    var totalPages: Int
    var currentPage: Int
}
