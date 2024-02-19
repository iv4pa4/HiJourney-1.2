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
                    Text(adventure.name).font(.title)
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
                .font(.title3)
                .lineLimit(3)
            
        }
        .padding()
        .onAppear{
            retrivePhoto(url: adventure.photoURL)
        }
        
        Spacer()
        
    }
    func retrivePhoto(url: String){
        Storage.storage().reference().child(url).downloadURL { (url, error) in
            DispatchQueue.main.async {
                guard let downloadURL = url else {
                    // Handle error, perhaps display a placeholder image
                    return
                }
        
                URLSession.shared.dataTask(with: downloadURL) { data, response, error in
                    guard let data = data else { return }
                    if let image = UIImage(data: data) {
                        retrivedImage = image
                        print("Succesfull")
                    }
                }.resume()
            }
        }
    }
      
    
}

#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String", photoURL: ""), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}
