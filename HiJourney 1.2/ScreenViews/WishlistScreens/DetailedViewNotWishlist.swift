//
//  DetailedViewNotWishlist.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 18.02.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct DetailedViewNotWishlist: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection
    @ObservedObject var viewModelAdv: AttendedAdventuresVModel
    @ObservedObject var userSession: UserSession
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
            .padding()
            
            
            VStack(alignment: .leading) {
                HStack {
                    Image("profilePic") // Profile image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(adventure.name).font(.title)
                    Spacer()

                    
                    Button(action: {
                        
                        viewModel.attendAdventures(adventurerId: currentAdventurer.id, adventureId: adventure.id)
                        viewModelAdv.getCurrAttendedAdventures(id: currentAdventurer.id)
                        
                    }) {
                        Text("Jump in")
                    }
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
    DetailedViewNotWishlist(adventure: ad, viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel(), userSession: UserSession())
}
