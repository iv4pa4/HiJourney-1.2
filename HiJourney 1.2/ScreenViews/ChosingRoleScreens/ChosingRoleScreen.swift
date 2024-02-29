//
//  ChosingRoleScreen.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct ChosingRoleScreen: View {
    @ObservedObject var viewModel: Connection
    @ObservedObject var creatorProps: CreatorViewModel
    @ObservedObject var userSession: UserSession
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 240
    private let offsetForButton2: CGFloat = 160
    private let logoWidth: CGFloat = 266
    private let logoHeight: CGFloat = 266
    var details = DetailedRoleView()

    
    var body: some View {
        NavigationView{
            VStack{
                    ZStack{
                        Image("wp3")
                        //DetailedRoleView()
                        VStack{
                            //chosingRoleText
                            adventurer
                            creator
                        }
                        
                    }
            }
        }.navigationBarBackButtonHidden()
    }
    
    var adventurer: some View {
        NavigationLink(
            destination: SignUpScreenView(viewModel: viewModel, userSession: userSession),
            label: {
                details.adventurerDeatiledRoleView
            })
    }
    //TODO: change to signup for creator
    var creator: some View {
        NavigationLink(
            destination: SignUpScreenViewCreator(viewModel: viewModel,userSession: userSession,creatorProps: CreatorViewModel()),
            label: {
                details.creatorDeatiledRoleView
            })
    }
    
    
    var chosingRoleText: some View{
        Text("What do you want to be?")
            .font(.largeTitle)
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
            
    }
}



#Preview {
    ChosingRoleScreen(viewModel: Connection(), creatorProps: CreatorViewModel(), userSession: UserSession())
}
