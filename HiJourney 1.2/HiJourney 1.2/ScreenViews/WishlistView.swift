////
////  WishlistView.swift
////  HiJourney 1.2
////
////  Created by Ivayla  Panayotova on 7.02.24.
////
//
//import SwiftUI
//
import SwiftUI

struct WishlistView: View {
    @ObservedObject var viewModel: Connection
    var body: some View {
            VStack {
                if wishlistItems.isEmpty {
                    Text("Loading...")
                } else {
                    List(wishlistItems, id: \.name) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchWishlistData()
            }
        }
    }

#Preview {
    WishlistView(viewModel: Connection())
}
