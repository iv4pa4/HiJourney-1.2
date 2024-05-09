//
//  CreatedAdventureDetailedPage.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//


import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage


struct CreatedAdventureDetailedPage: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection
    @ObservedObject var creatorProps: CreatorViewModel
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
                // User information and adventure title
                HStack {
                    Image("profilePic") // Profile image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(adventure.name)
                        .font(.custom("Poppins-Bold", size:40))
                    Spacer()
                    
                }
            }
            
            Text(adventure.description)
                .font(.custom("Poppins-Bold", size:15))
                
            
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
    CreatedAdventureDetailedPage(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String", photoURL: ""), viewModel: Connection(), creatorProps: CreatorViewModel())
}




