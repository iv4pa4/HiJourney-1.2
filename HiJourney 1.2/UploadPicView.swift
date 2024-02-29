//
//  UploadPicView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 18.02.24.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import URLImage

struct UploadPicView: View {
    @State var isPickerShowing = false
    @State var selectedImage : UIImage?
    @State var retrivedImage = UIImage()
    @State var url : String
    var body: some View {
        VStack{
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
            if selectedImage != nil {
                Button{
                   //print( uploadPhoto(adventureName: "iva"))
                    
                }
            label:{
                Text("Upload a photo")
            }
            }
            
            Image(uiImage: retrivedImage)
                .resizable()
                .frame(width: 200, height: 200)
            
            

        }.sheet(isPresented: $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .onAppear{
            retrivePhoto(url: url)
        }
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
    

    func retrivePhoto(url: String){
        Storage.storage().reference().child(url).downloadURL { (url, error) in
            DispatchQueue.main.async {
                guard let downloadURL = url else {
                    return
                }
        
                URLSession.shared.dataTask(with: downloadURL) { data, response, error in
                    guard let data = data else { return }
                    if let image = UIImage(data: data) {
                        retrivedImage = image
                        print("Succesfull")
                    }
                }.resume()
            }
        }
    }

    }


    



#Preview {
    UploadPicView(url: "iva871F6712-093F-4FA8-9228-DBB1FC557907")
}
