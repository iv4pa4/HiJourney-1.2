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

struct WishlistItem2: Identifiable, Decodable {
    var id: UUID // Use UUID instead of Int for the id
    let name: String
    let description: String
    
    // Custom Decodable initializer to set a default value for id
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.id = UUID() // Generate a random UUID for id
    }
    
    // CodingKeys to specify keys used for decoding
    enum CodingKeys: String, CodingKey {
        case name
        case description
    }
}

struct DiagonalGradientView: View {
    var squareFrame: CGFloat

    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("BlueForButtons"), location: 0.1),
                    .init(color: .white, location: 0.5),
                    .init(color: Color("nav_bar_bg"), location: 0.7),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .frame(width: squareFrame, height: squareFrame)
    }
}

struct DiagonalGradientViewRect: View {
    var squareFrameW: CGFloat
    var squareFrameH: CGFloat

    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("BlueForButtons"), location: 0.1),
                    .init(color: .white, location: 0.5),
                    .init(color: Color("nav_bar_bg"), location: 0.7),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .frame(width: squareFrameW, height: squareFrameH)
    }
}


