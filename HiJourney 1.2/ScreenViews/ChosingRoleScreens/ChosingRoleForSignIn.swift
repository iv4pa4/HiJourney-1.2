//
//  ChosingRoleForSignIn.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct ChosingRoleForSignIn: View {
    @ObservedObject var viewModel: Connection
    @ObservedObject var creatorProps: CreatorViewModel
    @ObservedObject var userSession: UserSession
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
        }.navigationBarBackButtonHidden(true)
    }
    
    var adventurer: some View {
        NavigationLink(
            destination: SignInViewScreen(viewModel: viewModel, userSession: userSession),
            label: {
                details.adventurerDeatiledRoleView
            })
    }
    //TODO: change to signup for creator
    var creator: some View {
        NavigationLink(
            destination: SignInViewCreatorScreen(viewModel: viewModel, creatorProps: creatorProps, userSession: userSession),
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
    ChosingRoleForSignIn(viewModel: Connection(), creatorProps: CreatorViewModel(), userSession: UserSession())
}
