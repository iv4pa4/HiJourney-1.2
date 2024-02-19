//
//  DetailedAdventureViewCreator.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 15.02.24.
//

import SwiftUI

struct DetailedAdventureViewCreator: View {
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
    DetailedAdventureViewCreator(adventure: Adventure(id: 8, name: "", description: "", creatorName: "", photoURL: "iva871F6712-093F-4FA8-9228-DBB1FC557907"), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}
