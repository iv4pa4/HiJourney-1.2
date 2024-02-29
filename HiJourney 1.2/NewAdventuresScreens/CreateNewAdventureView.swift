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
    private let offsetShowZone: CGFloat = 50
    private let offsetShowLogo: CGFloat = -162
    private let offsetSignUpText: CGFloat = -60
    private let signUpTextWidth: CGFloat = 128
    private let signUpTextHeight: CGFloat = 45
    private let signUpTextCornerRadius: CGFloat = 30
    private let signUpTextFontSize: CGFloat = 15


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
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                   // .offset(y:90)
                    .autocorrectionDisabled()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .textContentType(nil)
                
                TextField("Event Description", text: $eventDescription)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                   // .offset(y:90)
                    .autocorrectionDisabled()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .textContentType(nil)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                Button {
                    isPickerShowing =  true
                } label: {
                    Text("Choose image")
                        .foregroundColor(Color("BlueForButtons"))
                }
                
                Button(action: {
                    createEvent()
                }) {
                    Text("Create Event")
                        .frame(width: signUpTextWidth, height: signUpTextHeight)
                        .foregroundColor(.black)
                        .background(Color("BlueForButtons"))
                        .clipShape(RoundedRectangle(cornerRadius: signUpTextCornerRadius))
                       // .offset(y: offsetForButton)
                        .font(.custom("Poppins-Bold", size:signUpTextFontSize))

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
