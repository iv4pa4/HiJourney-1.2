//
//  DetailedAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI

struct DetailedAdventureView: View {
    var adventure: Adventure
        var body: some View {
               VStack {
                   HStack {
                       Image(systemName: "chevron.left")
                       Spacer()
        
                   }
                   .padding()

                   Image("rafting")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                   
                   // Scrollable horizontal images
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack {
                           ForEach(0..<5) { _ in
                               Image("rafting")
                                   .resizable()
                                   .frame(width: 80, height: 80)
                                   .cornerRadius(10)
                           }
                       }
                   }
                   .padding()


                   VStack(alignment: .leading) {
                       // User information and adventure title
                       HStack {
                           Image("profilePic") // Profile image
                               .resizable()
                               .clipShape(Circle())
                               .frame(width: 50, height: 50)
                           Text(adventure.creatorName).font(.headline)
                           Spacer()
                           Button(action: {
                           }) {
                               Image(systemName: "heart")
                           }
                           Button(action: {
                           }) {
                               Text("Jump in")
                                   .frame(width: 128, height: 45)
                                   .foregroundColor(.black)
                                   .background(Color("BlueForButtons"))
                                   .clipShape(RoundedRectangle(cornerRadius: 30))
                                   .font(.custom("Poppins-Bold", size:15))
                                   .shadow(color: .black, radius: 4, x: 3, y: 4)
                           }
                       }
                       
                       // Description text
                       Text(adventure.description)
                           .lineLimit(3)
                       
//                       Button("Read more") {
//                       }
//                       .foregroundColor(.blue)
                   }
                   .padding()
                   
                   Spacer()
               }
           }
}

#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String"))
}
