//
//  Constants.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 23.02.24.
//

import SwiftUI


var currentAdventurer = Adventurer(id: 0, username: "error", email: "error", password: "error", attendedAdventureIds: [], wishlistAdventureIds: [], connectedAdventurers: [])
 var currentCreator = Creator(id: 0, username: "error", email: "error", password: "error")

var urlForAdventure = "http://localhost:3001/adventure"
var urlForCreator = "http://localhost:3001/creator"
var urlForAdventurer = "http://localhost:3001/adventurer"
