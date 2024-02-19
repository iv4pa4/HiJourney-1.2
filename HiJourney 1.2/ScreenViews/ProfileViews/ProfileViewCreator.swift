//
//  ProfileViewCreator.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 15.02.24.
//

import SwiftUI

struct ProfileViewCreator: View {
    let adventurer: Adventurer
    @ObservedObject var attendedAdventuresVM = AttendedAdventuresVModel()
    
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
                
                //change to created
                
                if attendedAdventuresVM.attendedAdventures.isEmpty {
                    Text("Not created yet")
                        .font(.title2)
                        .padding(.top, 20)
                } else {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(attendedAdventuresVM.attendedAdventures, id: \.id) { adventure in
                            Text(adventure.name) // Display attended adventure name
                        }
                    }
                    .padding(.top, 20)
                }

                Spacer()
            }
            .onAppear {
                attendedAdventuresVM.getAttendedAdventures(adventurerId: adventurer.id)
            }
        }
    }
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileViewCreator(adventurer: Adventurer(id: 78, username: "test", email: "", password: "", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: []))
    }
}

