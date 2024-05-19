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
    @State private var isJumpedIn = false
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
                    Image("profilePic")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    Text(adventure.name)
                        .font(.custom("Poppins-Bold", size:25))
                    Spacer()
                    HeartButton(isliked: $isAddedToWishlist, viewModel: viewModel, adventure: adventure)
                    JumpInButton(isJumpedIn: $isJumpedIn, viewModel: viewModel, viewModelAdv: viewModelAdv, adventure: adventure)
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
            isAddedToWishlist = isAddedToWishlistOpt()
            isJumpedIn = isJumpedInOpt()
        }
        Spacer()
    }

      
    func isAddedToWishlistOpt() -> Bool{
        if currentAdventurer.wishlistAdventureIds.contains(adventure.id){
            return true
        }
        return false
    }
    func isJumpedInOpt() -> Bool{
        if currentAdventurer.attendedAdventureIds.contains(adventure.id) {
            return true
        }
        return false
    }
}

#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String", photoURL: ""), viewModel: Connection(), viewModelAdv: AttendedAdventuresVModel())
}

struct HeartButton : View{
    @Binding var isliked: Bool
   var viewModel: Connection
    var adventure: Adventure
    
    var body: some View{
        Button(action: {
            self.isliked.toggle()
            viewModel.addToWishlist(adventurerId: currentAdventurer.id, adventureId: adventure.id)
            viewModel.fetchWishlistData()
        }, label: {
                Image(systemName: isliked ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15)
                .foregroundColor(isliked ? .red : .gray)
            }
        )
    }
}

struct JumpInButton: View {
    @Binding var isJumpedIn: Bool
    var viewModel: Connection
    var viewModelAdv: AttendedAdventuresVModel
    var adventure: Adventure
    var body: some View {
        Button {
            self.isJumpedIn.toggle()
            viewModel.attendAdventures(adventurerId: currentAdventurer.id, adventureId: adventure.id)
            viewModelAdv.getCurrAttendedAdventures(id: currentAdventurer.id)
        } label: {
            Text(isJumpedIn ? "Jumped in" : "Jump in")
                .font(.custom("Poppins-Bold", size:15))
                .foregroundStyle(isJumpedIn ? .gray : .navBarBg)

        }

    }
}
