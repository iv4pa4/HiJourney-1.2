//
//  SignInScreenCreatorView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI


struct SignInScreenCreatorView: View {
    @ObservedObject var viewModel: Connection
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 260
    private let logoWidth: CGFloat = 156
    private let logoHeight: CGFloat = 149
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack{
            Image("wp3")
            showZone
            showLogo
            signInText
            usernameField()
            signInButton
            
        }
        .navigationBarBackButtonHidden(true)
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
            .offset(y: -162)
            
    }
    
    var signInText: some View{
        Text("Sign in")
            .font(.largeTitle)
            .foregroundColor(.black)
            .offset(y: -50)
    }
    
    var signInButton: some View{
        Button(action: {
            viewModel.signIn()
        }, label: {
            Text("Sign in")
                .frame(width: 128, height: 45)
                .foregroundColor(.black)
                .background(Color("BlueForButtons"))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .offset(y: offsetForButton)
                .font(.custom("Poppins-Bold", size:15))
                .shadow(color: .black, radius: 4, x: 3, y: 4)
        })
       
    }


    func usernameField() -> some View {
            VStack {
                TextField("Email", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(y:90)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .offset(y:120)
            }
            .frame(width: 300)
            .offset(y: -10)
    }
    
}



#Preview {
    SignInScreenCreatorView(viewModel: Connection())
}
