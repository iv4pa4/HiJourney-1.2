//
//  CreatorViewModel.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 21.02.24.
//

import Foundation

class CreatorViewModel : ObservableObject{
    @Published var createdAdventures: [AdventureFromCreator] = []
    @Published private var model = CreatorModel()


    func getAdventures(creatorId: Int) {
            guard let url = URL(string: "http://localhost:3001/creator/\(creatorId)/adventures") else {
                print("Invalid URL")
                return
            }

            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let decodedResponse = try? JSONDecoder().decode([AdventureFromCreator].self, from: data) {
                    DispatchQueue.main.async {
                        self.createdAdventures = decodedResponse
                    }
                    return
                }
                
                print("Failed to decode response")
            }.resume()
        }
    
    func createAdventure(eventName: String, eventDescription: String, photoURL: String, completion: @escaping (AdventureFromCreator?) -> Void){
        model.createAdventure(eventName: eventName, eventDescription: eventDescription, photoURL: photoURL, completion: completion)
    }
}
