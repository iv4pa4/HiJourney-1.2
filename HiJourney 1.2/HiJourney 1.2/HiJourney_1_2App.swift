//
//  HiJourney_1_2App.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 19.12.23.
//

import SwiftUI

@main
struct HiJourney_1_2App: App {
    var body: some Scene {
        WindowGroup {
            WelcomeScreenView(viewModel: Connection())
        }
    }
}
