//
//  CreateNewAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct CreateNewAdventureView: View {
    @State private var eventName = ""
    @State private var eventDescription = ""
    //@State private var selectedImage: UIImage?
    @State var imageURL: String = ""
    @State var selectedImage : UIImage?
    @State var isPickerShowing = false
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("Event Name", text: $eventName)
                    .padding()
                
                TextField("Event Description", text: $eventDescription)
                    .padding()
                
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                Button{
                    isPickerShowing =  true
                }
            label: {
                Text("Choose image")
            }
                
                
                Button(action: {
                    createEvent()
                }) {
                    Text("Create Event")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    
            }
            .navigationBarTitle("Add new adventure")
            
        }
        
        
    }
    
    func createEvent() {
        imageURL = uploadPhoto(adventureName: eventName)
        print(eventName)
        print(eventDescription)
        print(imageURL)
        createAdventure(eventName: eventName, eventDescription: eventDescription, photoURL: imageURL)
    }
    
    func uploadPhoto(adventureName: String) -> String {
        guard selectedImage != nil else {
            return ""
        }
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return ""
        }
        let path = "\(adventureName)\(UUID().uuidString)"
        let fileRef = storageRef.child(path)
        let uploadTask = fileRef.putData(imageData!, metadata: nil){ metadata,
            error in
            if error == nil && metadata != nil {
                
            }
        }
        return path
    }


    func createAdventure(eventName: String, eventDescription: String, photoURL: String) {
        // Your creator ID
        let url = URL(string: "http://localhost:3001/creator/\(currentCreator.id)/adventures")!
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "name": eventName,
            "description": eventDescription,
            "photoURL": photoURL
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    // Successful request
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []),
                       let json = responseData as? [String: Any] {
                        print("Adventure created successfully:", json)
                    }
                } else {
                    // Request failed
                    print("Failed to create adventure. Status code: \(httpResponse.statusCode)")
                    if let errorMessage = String(data: data, encoding: .utf8) {
                        print("Error message: \(errorMessage)")
                    }
                }
            }
        }
        task.resume()
    }


}

//struct CreateNewAdventureView: PreviewProvider {
//    static var previews: some View {
//        CreateEventView()
//    }
//}




#Preview {
    CreateNewAdventureView()
}
