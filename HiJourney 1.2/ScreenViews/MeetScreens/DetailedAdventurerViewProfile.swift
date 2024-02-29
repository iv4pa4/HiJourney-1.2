//
//  DetailedAdventurerViewProfile.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 13.02.24.
//

import SwiftUI

struct DetailedAdventurerViewProfile: View {
    let images = ["rafting", "adventure", "wp3", "rafting"]
    let adventurer: Adventurer
    @ObservedObject var viewModel: Connection
    @ObservedObject var userSession: UserSession
    @StateObject var attendedModel: AttendedAdventuresVModel
    
    @State private var isConnectButtonDisabled = false
    @State private var isConnectionSuccessful = false // Track connection state
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                Image("c")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                Text(adventurer.username)
                    .font(.title)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                
                if isConnectionSuccessful {
                    Text("Connected") // Show "Connected" text if connection is successful
                        .foregroundColor(.gray) // Lighter color
                        .padding(.top, 10)
                } else {
                    buttonConnect
                }
                
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(attendedModel.attendedAdventures, id: \.self) { adventure in
                       AttendedAdventuresView(adventure: adventure)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .onAppear{
                attendedModel.getCurrAttendedAdventures(id: adventurer.id)
            }
        }
    }
    
    var buttonConnect: some View{
        Button(action: {
                connectAdventurers(adventurerId1: currentAdventurer.id, adventurerId2: adventurer.id)
                isConnectButtonDisabled = true
                isConnectionSuccessful = true
            
        }) {
            Text("Connect")
        }
        .frame(width: 128, height: 45)
        .foregroundColor(.black)
        .background(isConnectionSuccessful ? Color.gray.opacity(0.5) : Color("BlueForButtons")) // Change background color if connected
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .font(.custom("Poppins-Bold", size:15))
        .shadow(color: .black, radius: 4, x: 3, y: 4)
        .disabled(isConnectButtonDisabled)
    }
    //BUG
    func connectAdventurers(adventurerId1: Int, adventurerId2: Int) {
        if let jwtToken = userSession.getJWTTokenFromKeychain() {
            print("JWT token retrieved successfully")
            viewModel.connectAdventurers(adventurerId1: adventurerId1, adventurerId2: adventurerId2, token: jwtToken)
        }
    }
}


#Preview {
    DetailedAdventurerViewProfile(adventurer: Adventurer(id: 9, username: "test", email: "", password: "", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: []), viewModel:Connection(), userSession: UserSession(), attendedModel: AttendedAdventuresVModel())
}


