//
//  WishlistAdventuresDisplayedView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct WishlistAdventuresDisplayedView: View {
    //TODO: fix to give the id and creator also
    @ObservedObject var viewModel: Connection
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.wishlist) { wish in // 
                        VStack(alignment: .leading) {
                            Text("Name: \(wish.name)")
                            Text("Description: \(wish.description)")
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Wishlist")
        }
    }
}




#Preview {
    WishlistAdventuresDisplayedView(viewModel: Connection())
}
