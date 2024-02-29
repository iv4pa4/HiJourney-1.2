//
//  AdventurerDetailedView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 13.02.24.
//

import SwiftUI

struct AdventurerDetailedView: View {
    var adventurer : Adventurer
    var body: some View {
        ZStack{
            base
            whiteBase
            VStack {
                profileImage
                adventurerUsername
            }
        }
    }
    
    var base: some View{
        DiagonalGradientView(squareFrame: 105)
            .cornerRadius(9)
    }
    var whiteBase: some View{
        Rectangle()
            .fill(.white)
            .cornerRadius(9)
            .frame(width: 90, height: 90)
    }
    var profileImage: some View {
        Image("c")
            .resizable()
            .frame(width: 65, height: 65)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .padding(.top, 3)
    }
    
    var adventurerUsername: some View {
        Text("@\(adventurer.username)")
            .padding(.top, 1)
            .bold()
            .foregroundColor(.black)
            .lineLimit(1) // Limit the text to one line
            .fixedSize(horizontal: false, vertical: true) // Ensure the text doesn't exceed its container
            .frame(maxWidth: 80) // Set a maximum width for the text
            .padding(.horizontal) // Add horizontal padding
    }

}

#Preview {
    AdventurerDetailedView(adventurer: Adventurer(id: 2, username: "test", email: "", password: "", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: []))
}
