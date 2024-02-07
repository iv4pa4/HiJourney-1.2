//
//  SwiftUIView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 7.02.24.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Create User") {
                print(username)
                print(email)
                print(password)
                createUser(username: username, email: email, password: password)
            }
            .padding()
        }
        .padding()
    }
    
    func createUser(username: String, email: String, password: String) {
        let adventurerDto = AdventurerDto(username: username, email: email, password: password)
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(adventurerDto)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    // Handle response data if needed
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                }
            }.resume()
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
        }
    }
}



#Preview {
    ContentView()
}
