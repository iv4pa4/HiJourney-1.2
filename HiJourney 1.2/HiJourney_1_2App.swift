//
//  HiJourney_1_2App.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI
import Firebase

@main
struct HiJourney_1_2App: App {
    var body: some Scene {
        WindowGroup {
            
            WelcomeScreenView(viewModel: Connection(), creatorProps: CreatorViewModel())
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
}
