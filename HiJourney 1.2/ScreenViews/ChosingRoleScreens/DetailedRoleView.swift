//
//  DetailedRoleView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct DetailedRoleView: View {
    var squareFrame: CGFloat = 300
    var sqFrame: CGFloat = 310
    var adventurerImageFrame: CGFloat = 180
    var body: some View {
        VStack{
            adventurerDeatiledRoleView
            creatorDeatiledRoleView
        }
    }
    
    var adventurerDeatiledRoleView: some View{
        ZStack{
            frameAdventurer
            baseAdventurer
            imageAdventurer
            textAdventurer
            
        }
    }
    
    var creatorDeatiledRoleView: some View{
        ZStack{
            frameAdventurer
            baseCreator
            imageCreator
            textCreator
        }
    }
    
    var frameAdventurer: some View{
        Rectangle()
            .fill(.white)
            .frame(width: sqFrame, height: sqFrame)
            .cornerRadius(25)
    }
    var baseAdventurer: some View{
        Rectangle()
            .fill(Color("nav_bar_bg"))
            .frame(width: squareFrame, height: squareFrame)
            .cornerRadius(25)
    }
    
    var imageAdventurer: some View{
        Image("adventurer")
            .resizable() 
            .frame(width: adventurerImageFrame, height: adventurerImageFrame)
            .padding(.bottom, 50)

    }
    var textAdventurer: some View{
        Text("Adventurer")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding(.top,190)
    }
    
    var baseCreator: some View{
        Rectangle()
            .fill(Color("BlueForButtons"))
            .frame(width: squareFrame, height: squareFrame)
            .cornerRadius(25)
    }
    var textCreator: some View{
        Text("Creator")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
            .padding(.top,190)
    }
    var imageCreator: some View{
        Image("creator")
            .resizable()
            .frame(width: adventurerImageFrame, height: adventurerImageFrame)
            .padding(.bottom, 50)

    }
}

#Preview {
    DetailedRoleView()
}
