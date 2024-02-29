//
//  SignInView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 13.02.24.
//

import SwiftUI



struct SignInViewScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @ObservedObject var viewModel: Connection
    @ObservedObject var userSession: UserSession
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 260
    private let logoWidth: CGFloat = 156
    private let logoHeight: CGFloat = 149
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("wp3")
                showZone
                showLogo
                signInText
                textFields
                signInButton
                
            }
            
            .background(NavigationLink(
                destination: ExploreMainPageScreen(viewModel: viewModel, userSession: userSession), // New view to navigate to
                isActive: $isSignedIn,
                label: { EmptyView() }
            ))
        }.navigationBarBackButtonHidden(true)
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
    
    var textFields: some View {
        VStack{
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(Color.black)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .textContentType(nil)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .border(Color.black)
                .offset(y:90)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .textContentType(nil)
        }
        .frame(width: 300)
        .offset(y: -10)
    }
    
    var signInButton: some View{
        Button(action: {
            viewModel.signIn(email: email, password: password) { result in
                switch result {
                case .success:
                    isSignedIn = true
                case .failure(let error):
                    
                    print("Sign-in failed: \(error.localizedDescription)")
                }
            }
        }, label: {
            Text("Sign in")
            
        })
        
        .frame(width: 128, height: 45)
        .foregroundColor(.black)
        .background(Color("BlueForButtons"))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .offset(y: offsetForButton)
        .font(.custom("Poppins-Bold", size:15))
        .shadow(color: .black, radius: 4, x: 3, y: 4)
    }
}

#Preview {
    SignInViewScreen(viewModel: Connection(), userSession: UserSession())
}
