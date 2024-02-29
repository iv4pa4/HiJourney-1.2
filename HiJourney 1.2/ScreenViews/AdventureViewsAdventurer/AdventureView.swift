//
//  AdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 25.01.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage


struct AdventureView: View {
    private let squareFrame:CGFloat = 320
   

    let adventure: Adventure
    @State var retrivedImage = UIImage(named: "default_picture")!
    //var imageSet : UploadPicView
    //var retrivedPhoto = UIImage()
    
    var body: some View {
        ZStack{
            showzone
            whiteBase
            VStack{
                adventureImage
                HStack{
                    titleText
                    Spacer()
                    profileImage
                    
                }
            }
            .frame(width: 280, height: 280)
            .cornerRadius(25)
            //.shadow(radius: 10)
            .padding(.top)
        }
        .shadow(radius: 5)
        .onAppear{
            PhotoRetriever.retrievePhoto(url: adventure.photoURL) { image in
                            if let image = image {
                                self.retrivedImage = image
                            } else {
                                print("failed")
                            }
                        }
        }
        
    }
    
   
    
    var showzone: some View {
        DiagonalGradientView(squareFrame: squareFrame).cornerRadius(30)
    }
    var adventureImage: some View {
        Image(uiImage:  retrivedImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .cornerRadius(25)
            .clipped()
    }
    var profileImage: some View {
        Image("profilePic")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    var titleText: some View {
        Text(adventure.name)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    } 
    var whiteBase: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 300, height: 300)
            .cornerRadius(30)
    }
    var profileText: some View {
        Text("Anna Smith").font(.headline)
    }
    
       

}

var ad = Adventure(id: 220, name: "Chip", description: "Chipoo", creatorName: "ivka", photoURL: "iva857A4B24-E2CA-4808-9873-36E73714B3FB")

#Preview {
    AdventureView(adventure: ad)
}
