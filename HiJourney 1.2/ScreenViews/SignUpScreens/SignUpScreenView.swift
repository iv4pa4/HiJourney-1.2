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
    @State var profilephoto: String = ""
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
    @ObservedObject var userSession : UserSession
    
    var body: some View {
        NavigationView{
            ZStack{
                Image("wp3")
                showZone
                showLogo
                signUpText
                textFieldUsername
                button
                NavigationLink(destination: ExploreMainPageScreen(viewModel: viewModel, userSession: userSession), isActive: $navigateToExplore) {
                    EmptyView()
                                }.navigationBarBackButtonHidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    var button: some View {
        Button(action: {
            createUser(username: self.username, email: self.email, password: self.password, profilephoto: profilephoto)
        }) {
            Text("Sign Up")
        }
        .frame(width: signUpTextWidth, height: signUpTextHeight)
        .foregroundColor(.black)
        .background(Color("BlueForButtons"))
        .clipShape(RoundedRectangle(cornerRadius: signUpTextCornerRadius))
        .offset(y: offsetForButton)
        .font(.custom("Poppins-Bold", size:signUpTextFontSize))
    }

    
    var textFieldUsername: some View{
        VStack{
            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .textContentType(nil)
                
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .textContentType(nil)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .textContentType(nil)
            SecureField("Retype password", text: $repassword)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .textContentType(nil)
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
            .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            
    }
    
    var signUpText: some View{
        Text("Sign up")
            .font(.custom("Poppins-Bold", size:45))
            .foregroundColor(.black)
            .offset(y: offsetSignUpText)
            .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        
    }
        
    
    func createUser(username: String, email: String, password: String, profilephoto: String) {
        viewModel.createUserAdventurer(username: username, email: email, password: password, profilephoto: profilephoto) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.navigateToExplore = true
                }
            case .failure(let error):
                print("User NOT created \(error)")
            }
        }
    }

    
}


#Preview {
    SignUpScreenView(viewModel: Connection(), userSession: UserSession())
}
