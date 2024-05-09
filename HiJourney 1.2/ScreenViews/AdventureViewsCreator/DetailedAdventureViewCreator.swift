//
//  DetailedAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage


struct DetailedAdventureViewCreator: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection
    @ObservedObject var viewModelAdv: AttendedAdventuresVModel
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
                        .font(.custom("Poppins-Bold", size:25))
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
    DetailedAdventureViewCreator(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String", photoURL: ""), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}
