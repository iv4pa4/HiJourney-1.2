//
//  ContentView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 14.02.24.
//

import SwiftUI
//fix appearance
struct ConnectedAdventurersDisplayView: View {
    //@State private var adventurers = [AdventurerDtoRes]()
    @ObservedObject var adventurerProps : AdventurerViewModel
    @ObservedObject var userSession : UserSession
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(adventurerProps.connectedAdventurers, id: \.id) {adventurer in
                    
                        AdventurerDetailedView(adventurer: Adventurer(id: adventurer.id, username: adventurer.username, email: adventurer.email, password: "", attendedAdventureIds: adventurer.attendedAdventureIds, wishlistAdventureIds: adventurer.wishlistAdventureIds, connectedAdventurers: []))
                    }
            }
            .onAppear {
                    adventurerProps.fetchAdventurers(id: currentAdventurer.id)
                
            }
            .navigationTitle("Connected adventurers")
        }
    }
    
   
}


#Preview {
    ConnectedAdventurersDisplayView(adventurerProps: AdventurerViewModel(), userSession: UserSession())
}
