//
//  ProfileViewCreator.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 15.02.24.
//

import SwiftUI

struct ProfileViewCreator: View {
    let creator: Creator
    @ObservedObject var creatorProps : CreatorViewModel

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

                Text(creator.username)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.top, 20)
                
                
                if creatorProps.createdAdventures.isEmpty {
                    Text("Not created yet")
                        .font(.title2)
                        .padding(.top, 20)
                } else {
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(creatorProps.createdAdventures, id: \.id) { adventure in
                            NavigationLink(destination: CreatedAdventureDetailedPage(adventure: Adventure(id: adventure.id, name: adventure.name, description: adventure.description, creatorName: adventure.creator.username, photoURL: adventure.photoURL), viewModel: Connection(), creatorProps: creatorProps)) {
                                DetailedCreatedView(adventure: adventure)
                            }
                        }
                    }
                    .padding(.top, 20)
                }

                Spacer()
            }
            .onAppear {
                creatorProps.getAdventures(creatorId: creator.id)
            }
        }
    }
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileViewCreator(creator: Creator(id: 17, username: "test", email: "", password: "lll"), creatorProps: CreatorViewModel())
    }
}

