//
//  DetailedAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI

struct DetailedAdventureView: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection
    @ObservedObject var viewModelAdv: AttendedAdventuresVModel
    
    @State private var isAddedToWishlist = false
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
                        viewModel.addToWishlist(adventurerId: currentAdventurer.id, adventureId: adventure.id)
                        viewModel.fetchWishlistData()
                    }) {
                        Image(systemName: isAddedToWishlist ? "heart.fill" : "heart")
                    }
                    .padding()
                    
                    Button(action: {
                        viewModel.attendAdventures(adventurerId: currentAdventurer.id, adventureId: adventure.id)
                        viewModelAdv.getCurrAttendedAdventures()
                    }) {
                        Text("Jump in")
                    }
                }
            }
            
            Text(adventure.description)
                .lineLimit(3)
            
        }
        .padding()
        
        Spacer()
        
    }
    
}

#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String"), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}
