//
//  ContentView.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI


struct SignUpScreenView: View {
    
    @ObservedObject var viewModel: Connection
    private let rectangleWidth: CGFloat = 350
    private let rectangleHeight: CGFloat = 670
    private let offsetForButton: CGFloat = 260
    private let logoWidth: CGFloat = 156
    private let logoHeight: CGFloat = 149
    @State var username: String = ""
    @State var password: String = ""
    @State var repassword: String = ""
    @State var email: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Image("wp3")
                showZone
                showLogo
                signUpText
                usernameField()
                signInButton
            }
        }
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
    
    var signUpText: some View{
        Text("Sign up")
            .font(.largeTitle)
            .foregroundColor(.black)
            .offset(y: -60)
    }
    
    var signInButton: some View{
        Button(action: {
            viewModel.signUp()
        }, label: {
            Text("Sign up")
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
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .border(Color.black)
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
                    .border(Color.black)
                    .offset(y:90)
            }
            .frame(width: 300)
    }
    
}




//#Preview {
//    SignUpScreenView(viewModel: Connection())
//}
