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
   // var profilephoto: String 
}


struct CreatorDTORes: Decodable {
    let id: Int
    let username: String
    let email: String
    let password: String
}

struct AdventureResponseDto: Hashable, Codable {
    var id: Int
    var name: String
    var description: String
    var attendedAdventurerIds: [Int]
}


struct Adventure: Identifiable, Decodable {
    var id: Int
    var name: String
    var description: String
    var creatorName: String
    var photoURL: String
}

struct SearchAdventure: Identifiable, Decodable {
    var id: Int
    var name: String
    var description: String
    var attendedAdventurerIds: [Int]
    var photoURL: String
}

struct AdventureRes: Identifiable, Decodable {
    var id: Int
    var name: String
    var description: String
}


struct AdventurerResponse: Codable {
    var items: [Adventurer]
}


class CreatorDto : Codable {
    let username: String
    let email: String
    let password: String

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
}


struct WishlistItem: Identifiable, Decodable {
    let id:  Int
    let name: String
    let description: String
    let photoURL: String

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


