//  DetailedWishlistViewScreen.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 8.02.24.
//

import SwiftUI

struct DetailedWishlistViewScreen: View {
    private var squareFrameW: CGFloat = 300
    private var squareFrameH: CGFloat = 150
    private var squareFrameHPicture: CGFloat = 150
    private var squareFrameWPicture: CGFloat = 265
    private var cornerRadius: CGFloat = 20
    var wishlistAdventure: WishlistItem2
    
    init(wishlistAdventure: WishlistItem2) {
           self.wishlistAdventure = wishlistAdventure
       }
    
    var body: some View {
        ZStack {
            gradientBase
            whiteBase {
                HStack {
                    generateAdventureImage(url: "rafting")
                    Spacer()
                    titleText(title: wishlistAdventure.name)
                }
            }
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
        Image(url)
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
}


//#Preview {
//    DetailedWishlistViewScreen(wishlistAdventure: WishlistItem2())
//}

