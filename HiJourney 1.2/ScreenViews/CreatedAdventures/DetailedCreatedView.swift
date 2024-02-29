//
//  DetailedCreatedView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import SwiftUI

struct DetailedCreatedView : View{
   let adventure: AdventureFromCreator
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

var cr = Creator(id: 8, username: "viva", email: "v@gmail.com", password: "vivaa")
#Preview {
    DetailedCreatedView(adventure: AdventureFromCreator(id: 17, name: "Oppp", description: "jsnxajksxbhjksxkjasx", photoURL: "iva795BA9CB-3AE9-4386-AD87-DE578A2F63F4", attendedAdventurerIds: [], creator: cr))
}
