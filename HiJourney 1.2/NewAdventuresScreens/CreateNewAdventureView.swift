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
    @State var imageURL: String = ""
    @State var selectedImage : UIImage?
    @State var isPickerShowing = false
    @ObservedObject var creatorProps : CreatorViewModel
    @State private var isCreated = false
    @State private var createdAdventure = AdventureFromCreator(id: 0, name: "", description: "", photoURL: "", attendedAdventurerIds: [], creator: Creator(id: 0, username: "", email: "", password: ""))

    
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("Event Name", text: $eventName)
                    .padding()
                
                TextField("Event Description", text: $eventDescription)
                    .padding()
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                Button {
                    isPickerShowing =  true
                } label: {
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
            .background(NavigationLink(
                destination: CreatedAdventureDetailedPage(adventure: Adventure(id: createdAdventure.id, name: createdAdventure.name, description: createdAdventure.description, creatorName: createdAdventure.creator.username, photoURL: createdAdventure.photoURL), viewModel: Connection(), creatorProps: creatorProps), // New view to navigate to
                isActive: $isCreated,
                label: { EmptyView() }
            ))
            .navigationBarTitle("Add new adventure")
            
        }
    }
    
    func createEvent() {
        guard let selectedImage = selectedImage else {
            print("Please select an image")
            return
        }
        
        PhotoUploader.uploadPhoto(image: selectedImage, adventureName: eventName) { path in
            guard let imagePath = path else {
                print("Failed to upload image")
                return
            }
            imageURL = imagePath
            print(eventName)
            print(eventDescription)
            print(imageURL)
            creatorProps.createAdventure(eventName: eventName, eventDescription: eventDescription, photoURL: imageURL) { createdAdventure in
                            if let createdAdventure = createdAdventure {
                                self.createdAdventure = createdAdventure
                                isCreated = true
                            } else {
                                
                            }
                        }
        }
    }




}




#Preview {
    CreateNewAdventureView(creatorProps: CreatorViewModel())
}
