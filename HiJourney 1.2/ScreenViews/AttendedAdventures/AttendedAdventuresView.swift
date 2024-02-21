//
//  AttendedAdventuresView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 19.02.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct AttendedAdventuresView: View {
    let adventure: AdventureRes
    @State var retrivedImage = UIImage(named: "default_picture")!
    var body: some View {
        VStack{
            adventureImage
        }
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
   
    var adventureImage: some View {
        Image(uiImage:  retrivedImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .cornerRadius(25)
            .clipped()
    }
    
}

#Preview {
    AttendedAdventuresView(adventure: AdventureRes(id: 5, name: "Blossom", description: "heheheheheeh",  photoURL: "iva795BA9CB-3AE9-4386-AD87-DE578A2F63F4"))
}
