//
//  CreateNewAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI

struct CreateNewAdventureView: View {
    @State private var adventureTitle: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var isPaidEvent: Bool = false
    @ObservedObject var viewModel: Connection
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Adventure Title")) {
                    TextField("Text input", text: $adventureTitle)
                }
                
                Section(header: Text("Add Photos")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<3) { _ in
                                Button(action: {
                                    //TODO  Action to add photo
                                }) {
                                    Image(systemName: "plus")
                                        .frame(width: 60, height: 60)
                                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Description")) {
                    TextField("Text input", text: $description)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Date picker", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Toggle(isOn: $isPaidEvent) {
                        Text("Paid event")
                    }
                }
                

                    Button("Create Adventure") {
                        //TODO Action to create adventure
                    }
                    .frame(width: 128, height: 45)
                    .foregroundColor(.black)
                    .background(Color("BlueForButtons"))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .font(.custom("Poppins-Bold", size:15))
                    .shadow(color: .black, radius: 4, x: 3, y: 4)
                    
                }
            .navigationBarTitle("Create Adventure", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                // TODO Action for back button
            }) {
                Image(systemName: "chevron.left")
            })
        }
    }
    
    
}



#Preview {
    CreateNewAdventureView(viewModel: Connection())
}
