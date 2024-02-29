//
//  DetailedWishlistViewPage.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage


struct DetailedAdventureWishlistViewPage: View {
    var adventure: WishlistItem
    @ObservedObject var viewModel: Connection
   // @ObservedObject var viewModelAdv: AttendedAdventuresVModel
    @State var retrivedImage = UIImage(named: "default_picture")!

    
    @State private var isAddedToWishlist = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
            }
            .padding()
            
            Image(uiImage: retrivedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Scrollable horizontal images
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(0..<5) { _ in
//                        Image("rafting")
//                            .resizable()
//                            .frame(width: 80, height: 80)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//            .padding()
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image("profilePic") // Profile image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(adventure.name).font(.title)
                    Spacer()
                    
                }
            }
            
            Text(adventure.description)
                .font(.title3)
                .lineLimit(3)
            
        }
        .padding()
        .onAppear{
            PhotoRetriever.retrievePhoto(url: adventure.photoURL) { image in
                            if let image = image {
                                self.retrivedImage = image
                            } else {
                                print("failed")
                            }
                        }
        }
        
        Spacer()
        
    }
      
    
}

#Preview {
    DetailedAdventureWishlistViewPage(adventure: WishlistItem(id: 2, name: "String", description: "String", photoURL: ""), viewModel: Connection())
}


