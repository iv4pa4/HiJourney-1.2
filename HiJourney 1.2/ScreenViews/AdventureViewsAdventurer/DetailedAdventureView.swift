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


struct DetailedAdventureView: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection
    @ObservedObject var viewModelAdv: AttendedAdventuresVModel
    @ObservedObject var userSession = UserSession()
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
            
            VStack(alignment: .leading) {
                HStack {
                    Image("profilePic") // Profile image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(adventure.name)
                        .font(.custom("Poppins-Bold", size:25))
                    Spacer()
                    wishlistButton
                    
                    // Check if adventure ID exists in attended adventures
                    if !currentAdventurer.attendedAdventureIds.contains(adventure.id) {
                        Button(action: {
                            viewModel.attendAdventures(adventurerId: currentAdventurer.id, adventureId: adventure.id)
                            viewModelAdv.getCurrAttendedAdventures(id: currentAdventurer.id)
                        }) {
                            Text("Jump in")
                                .font(.custom("Poppins-Bold", size:15))
                        }
                    }
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

    
    var wishlistButton: some View {
            Button(action: {
                viewModel.addToWishlist(adventurerId: currentAdventurer.id, adventureId: adventure.id)
                viewModel.fetchWishlistData()
            }) {
                Image(systemName: currentAdventurer.wishlistAdventureIds.contains(adventure.id) ? "heart.fill" : "heart")
                    .padding()
            }
            .foregroundColor(currentAdventurer.wishlistAdventureIds.contains(adventure.id) ? .red : .black)
        }
      
    
}

#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String", photoURL: ""), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}
