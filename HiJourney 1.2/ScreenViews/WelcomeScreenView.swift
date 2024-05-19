//
//  WelcomeScreenView.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

struct WelcomeScreenView: View {
    @ObservedObject var viewModel: Connection
    @ObservedObject var creatorProps: CreatorViewModel
    @ObservedObject var userSession: UserSession
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 240
    private let offsetForButton2: CGFloat = 160
    private let logoWidth: CGFloat = 266
    private let logoHeight: CGFloat = 266
    @State private var isSignedIn = false // Track sign-in status
    @State private var isSignedInCreator = false // Track sign-in status
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("wp3")
                showZone
                showLogo
                signUpText
                signUpLink
                signInLink
                
            }
            .background(
                Group {
                    if isSignedIn {
                        NavigationLink(
                            destination: ExploreMainPageScreen(viewModel: viewModel, userSession: userSession),
                            isActive: $isSignedIn,
                            label: { EmptyView() }
                        )
                    } else if isSignedInCreator {
                        NavigationLink(
                            destination: ExploreMainScreenCreator(viewModel: Connection(), creatorProps: CreatorViewModel(), userSession: UserSession()),
                            isActive: $isSignedInCreator,
                            label: { EmptyView() }
                        )
                    } else {
                        EmptyView()
                    }
                }
            )
                        .onAppear {
                            trySignIn()
                        }
                    }
        .navigationBarBackButtonHidden(true)
                }
    
                
    func trySignIn() {
        let jwt = userSession.getJWTTokenFromKeychain()
        let adventurer = AdventurerSaver.loadAdventurer()
        let creator = CreatorSaver.loadCreator()
        if jwt != nil {
            if adventurer != nil{
                currentAdventurer = adventurer!
                isSignedIn = true
            }
            if creator != nil{
                currentCreator = creator!
                isSignedInCreator = true
            }
        }
    }
        
        var signUpLink: some View{
            NavigationLink(
                destination: ChosingRoleScreen(viewModel: viewModel, creatorProps: creatorProps, userSession: userSession),
                label: {
                    Text("Sign Up")
                        .frame(width: 128, height: 45)
                        .foregroundColor(.black)
                        .background(Color("BlueForButtons"))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .font(.custom("Poppins-Bold", size:15))
                        .shadow(color: .black, radius: 4, x: 3, y: 4)
                    //.offset(y: offsetForButton2)
                }).offset(y: offsetForButton2)
        }
        
        var signInLink: some View{
            NavigationLink(
                destination: ChosingRoleForSignIn(viewModel: viewModel, creatorProps: creatorProps, userSession: userSession),
                label: {
                    Text("Sign in")
                        .frame(width: 128, height: 45)
                        .foregroundColor(.black)
                        .background(Color("BlueForButtons"))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .font(.custom("Poppins-Bold", size:15))
                        .shadow(color: .black, radius: 4, x: 3, y: 4)
                }).offset(y: offsetForButton)
        }
        
        var showZone: some View{
            Rectangle()
                .fill(.white)
                .frame(width: rectangleWidth, height: rectangleHeight)
                .cornerRadius(50)
        }
        
        
        var showLogo: some View{
            Image("logo_new")
                .resizable()
                .frame(width: logoWidth, height: logoHeight)
                .offset(y: -92)
            
        }
        
        var signUpText: some View{
            Text("Welcome")
                .font(.custom("Poppins-Bold", size:40))
                .foregroundColor(.black)
                .offset(y: 80)
        }
    }



#Preview {
    WelcomeScreenView(viewModel: Connection(), creatorProps: CreatorViewModel(), userSession: UserSession())
}
