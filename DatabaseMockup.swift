//
//  DatabaseMockup.swift
//  HiJourney
//
//  Created by Ivayla  Panayotova on 18.12.23.
//

import Foundation

    struct User{
        let email: String
        let password: String
        init(email: String, password: String) {
            self.email = email
            self.password = sha256(password)
        }
    }
    
    struct Event{
        let id: Int
        let name: String
        let descripton: String
        let image: String
        var attendedFriends: [User]
        
        init(id: Int, name: String, descripton: String, image: String, attendedFriends: [User]) {
            self.id = id
            self.name = name
            self.descripton = descripton
            self.image = image
            self.attendedFriends = attendedFriends
        }
    }
    
    struct Adventurer{
        let id: Int
        let email: String
        let password: String
        let username: String
        var friends: [Adventurer]
        var attentedEvents: [Event]
        
        init(id: Int, email: String, password: String, username: String, friends: [Adventurer], attentedEvents: [Event]) {
            self.id = id
            self.email = email
            self.password = password
            self.username = username
            self.friends = friends
            self.attentedEvents = attentedEvents
        }
    }
    
    struct Creator{
        let id: Int
        let email: String
        let password: String
        let username: String
        var createdEvents: [Event]
    }


