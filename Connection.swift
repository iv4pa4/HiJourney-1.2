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
        model.signIn()
    }
    func signUp(){
        model.signUp()
    }
}

