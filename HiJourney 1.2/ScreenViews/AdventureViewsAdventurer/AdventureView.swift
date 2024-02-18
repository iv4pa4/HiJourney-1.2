//
//  AdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 25.01.24.
//

import SwiftUI

struct AdventureView: View {
    private let squareFrame:CGFloat = 320
    let title: String
    let adventurePhoto: String
    let profilePhoto: String
    var body: some View {
        ZStack{
            showzone
            whiteBase
            VStack{
                adventureImage
                //Spacer()
                HStack{
                    titleText
                    Spacer()
                    profileImage
                    
                }
            }
            .frame(width: 280, height: 280)
            .cornerRadius(25)
            //.shadow(radius: 10)
            .padding(.top)
        }
        .shadow(radius: 5)
    }
    
    var showzone: some View {
        DiagonalGradientView(squareFrame: squareFrame).cornerRadius(30)
    }
    var adventureImage: some View {
        Image(adventurePhoto)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .cornerRadius(25)
            .clipped()
    }
    var profileImage: some View {
        Image(profilePhoto)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    var titleText: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    } 
    var whiteBase: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 300, height: 300)
            .cornerRadius(30)
    }
    var profileText: some View {
        Text("Anna Smith").font(.headline)
    }
    
    

}



#Preview {
    AdventureView(title: "Rafting", adventurePhoto: "adventure", profilePhoto: "profilePic")
}
