//
//  WelcomeScreenView.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

struct WelcomeScreenView: View {
    @ObservedObject var viewModel: Connection
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 240
    private let offsetForButton2: CGFloat = 160
    private let logoWidth: CGFloat = 266
    private let logoHeight: CGFloat = 266

    
    var body: some View {
        NavigationView{
                ZStack{
                    Image("wp3")
                    showZone
                    showLogo
                    signUpText
                    signUpLink
                    signInLink
                    
            }
        }
    }
    
    var signUpLink: some View{
        NavigationLink(
            destination: SignUpScreenView(viewModel: viewModel),
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
            destination: SignInScreenView(viewModel: viewModel),
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
            .font(.largeTitle)
            .foregroundColor(.black)
            .offset(y: 80)
    }
}



#Preview {
    WelcomeScreenView(viewModel: Connection())
}
