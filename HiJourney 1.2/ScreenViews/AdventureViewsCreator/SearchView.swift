//
//  SearchView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 16.02.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct SearchView: View {
    private var squareFrameW: CGFloat = 300
    private var squareFrameH: CGFloat = 150
    private var squareFrameHPicture: CGFloat = 150
    private var squareFrameWPicture: CGFloat = 265
    private var cornerRadius: CGFloat = 20
    @State var retrivedImage = UIImage(named: "default_picture")!
    var adventure: SearchAdventure
    
    init(adventure: SearchAdventure) {
           self.adventure = adventure
       }
    
    var body: some View {
        ZStack {
            gradientBase
            whiteBase {
                HStack {
                    generateAdventureImage(url: "rafting")
                    Spacer()
                    titleText(title: adventure.name)
                }
            }
        }
        .onAppear{
            retrivePhoto(url: adventure.photoURL)
        }
    }
    
    var gradientBase: some View {
        DiagonalGradientViewRect(squareFrameW: squareFrameW, squareFrameH: squareFrameH)
            .cornerRadius(cornerRadius)
    }
    
    func whiteBase<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        Rectangle()
            .frame(width: squareFrameW - 20, height: squareFrameH - 20)
            .foregroundColor(.white)
            .cornerRadius(cornerRadius)
            .overlay(content())
    }
    
    func generateAdventureImage(url: String) -> some View {
        Image(uiImage: retrivedImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: squareFrameWPicture - 120)
            .cornerRadius(25)
            .clipped()
            .padding(.leading, 5)
    }
    
    func titleText(title: String) -> some View {
        Text(title)
            .bold()
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
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
    SearchView(adventure: SearchAdventure(id: 10, name: "ohio", description: "learning", attendedAdventurerIds: [], photoURL: ""))
}
