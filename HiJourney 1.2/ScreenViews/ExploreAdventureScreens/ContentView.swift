////
////  ContentView.swift
////  HiJourney 1.2
////
////  Created by Ivayla  Panayotova on 14.02.24.
////
//
//import SwiftUI
//
//
//struct ContentView: View {
//    @State private var email = ""
//    @State private var password = ""
//    
//    var body: some View {
//        VStack {
//            
//            
//            Button(action: {
//                he(email: "s@gmail.com", password: "s12345")
//            }) {
//                Text("Login")
//            }
//            .padding()
//            
//            
//        }
//        .padding()
//    }
//                   
//    func he(email: String, password: String){
//        getToken(email: email, password: password) { result in
//            switch result {
//            case .success(let token):
//                print("Token: \(token)")
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//        
//    
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
