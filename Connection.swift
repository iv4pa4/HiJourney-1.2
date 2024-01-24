//
//  Connection.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

class Connection: ObservableObject {
    @Published private var model = Logic()
    //@Published private var databaseMockup = DatabaseMockup()

    func signIn() {
        
    }
    func signUp(){
        
    }
    func signUpNewUser(username: String, email: String,  password: String){
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username" : username,
            "email" : email,
            "password" : password
        ]
        request.httpBody  = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("Success: \(response)")
            }
            catch {
                print (error)
            }
        }
        task.resume()
         
    }
    
    func signUpNewUserRes(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": username,
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, error == nil {
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("Success: \(response)")
                    completion(true)
                } catch {
                    print(error)
                    completion(false)
                }
            } else {
                print(error as Any)
                completion(false)
            }
        }
        task.resume()
    }



}

