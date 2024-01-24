//
//  SwiftUIView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 24.01.24.
//

import SwiftUI

struct SignUpScreenView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var repassword: String = ""
    @State private var navigateToExplore = false
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 260
    private let logoWidth: CGFloat = 156
    private let logoHeight: CGFloat = 149
    private let offsetShowZone: CGFloat = 50
    private let offsetShowLogo: CGFloat = -162
    private let offsetSignUpText: CGFloat = -60
    private let signUpTextWidth: CGFloat = 128
    private let signUpTextHeight: CGFloat = 45
    private let signUpTextCornerRadius: CGFloat = 30
    private let signUpTextFontSize: CGFloat = 15
    @ObservedObject var viewModel: Connection
    var body: some View {
        NavigationView{
            ZStack{
                Image("wp3")
                showZone
                showLogo
                signUpText
                textFieldUsername
                button
                NavigationLink(destination: ExploreMainPageScreen(), isActive: $navigateToExplore) {
                    EmptyView()
                                }
            }
        }
        
    }
    var button: some View {
        Button("Sign Up")
        {
            print(username)
            print(email)
            print(password)
            print(repassword)
            signUpNewUser(username: username, email: email, password: password)
        }
        .frame(width: signUpTextWidth, height: signUpTextHeight)
        .foregroundColor(.black)
        .background(Color("BlueForButtons"))
        .clipShape(RoundedRectangle(cornerRadius: signUpTextCornerRadius))
        .offset(y: offsetForButton)
        .font(.custom("Poppins-Bold", size:signUpTextFontSize))
        .shadow(color: .black, radius: 4, x: 3, y: 4)
    }

    
    var textFieldUsername: some View{
        VStack{
            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
            TextField("Email", text: $email)
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
                .offset(y:90)
            SecureField("Retype password", text: $repassword)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
        }
        .frame(width: 300)
    }
    
    var showZone: some View{
        Rectangle()
            .fill(.white)
            .frame(width: rectangleWidth, height: rectangleHeight)
            .cornerRadius(offsetShowZone)
    }
    
    var showLogo: some View{
        Image("logo_new")
            .resizable()
            .frame(width: logoWidth, height: logoHeight)
            .offset(y: offsetShowLogo)
            
    }
    
    var signUpText: some View{
        Text("Sign up")
            .font(.largeTitle)
            .foregroundColor(.black)
            .offset(y: offsetSignUpText)
    }
        
    
    func signUpNewUser(username: String, email: String, password: String){
        viewModel.signUpNewUserRes(username: username, email: email, password: password) { success in
            if success {
                self.navigateToExplore = true
            }
        }

    }
    
    
}


#Preview {
    SignUpScreenView(viewModel: Connection())
}
