//
//  HiJourneyApp.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 15.12.23.
//

import SwiftUI

@main
struct HiJourneyApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeScreenView(viewModel: Connection())
        }
    }
}
