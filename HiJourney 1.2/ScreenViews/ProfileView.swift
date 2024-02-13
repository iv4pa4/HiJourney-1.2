//
//  ProfileView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI

struct ProfileView: View {
    // Sample data for the grid
    let images = ["rafting", "adventure", "wp3", "rafting"]
    let adventurer: Adventurer

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack {
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 50)

                Text(adventurer.username)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.top, 20)


                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
        }
    }
}


//#Preview {
//    ProfileView()
//}
