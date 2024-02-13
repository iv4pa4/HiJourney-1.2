//
//  ChosingRoleForSignIn.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct ChosingRoleForSignIn: View {
    @ObservedObject var viewModel: Connection
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 240
    private let offsetForButton2: CGFloat = 160
    var details = DetailedRoleView()

    
    var body: some View {
        NavigationView{
            VStack{
                    ZStack{
                        Image("wp3")
                        VStack{
                            adventurer
                            creator
                        }
                        
                    }
            }
        }.navigationBarBackButtonHidden()
    }
    
    var adventurer: some View {
        NavigationLink(
            destination: SignInScreenView(viewModel: viewModel),
            label: {
                details.adventurerDeatiledRoleView
            })
    }
    //TODO: change to signup for creator
    var creator: some View {
        NavigationLink(
            destination: SignInScreenCreatorView(viewModel: viewModel),
            label: {
                details.creatorDeatiledRoleView
            })
    }
    
    
    var chosingRoleText: some View{
        Text("What do you want to be?")
            .font(.largeTitle)
            .foregroundColor(.black)
            //.offset(y: -190)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            
    }
}


#Preview {
    ChosingRoleForSignIn(viewModel: Connection())
}
