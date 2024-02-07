//
//  DetailedAdventureView.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 26.01.24.
//

import SwiftUI

struct DetailedAdventureView: View {
    var adventure: Adventure
    @ObservedObject var viewModel: Connection

        @State private var isAddedToWishlist = false
        var body: some View {
               VStack {
                   HStack {
                       Image(systemName: "chevron.left")
                       Spacer()
        
                   }
                   .padding()

                   Image("rafting")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                   
                   // Scrollable horizontal images
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack {
                           ForEach(0..<5) { _ in
                               Image("rafting")
                                   .resizable()
                                   .frame(width: 80, height: 80)
                                   .cornerRadius(10)
                           }
                       }
                   }
                   .padding()


                   VStack(alignment: .leading) {
                       // User information and adventure title
                       HStack {
                           Image("profilePic") // Profile image
                               .resizable()
                               .clipShape(Circle())
                               .frame(width: 50, height: 50)
                           Text(adventure.creatorName).font(.headline)
                           Spacer()
                           Button(action: {
                           }) {
                               Image(systemName: "heart")
                           }
                           Button(action: {
                                           addToWishlist()
                               viewModel.fetchWishlistData()
                                       }) {
                                           Image(systemName: isAddedToWishlist ? "heart.fill" : "heart")
                                       }
                                       .padding()
                                   }
                       }
                       
                       // Description text
                       Text(adventure.description)
                           .lineLimit(3)
                       
//                       Button("Read more") {
//                       }
//                       .foregroundColor(.blue)
                   }
                   .padding()
                   
                   Spacer()
            
               }
    func addToWishlist() {
        guard let url = URL(string: "http://localhost:3001/adventurer/\(currentAdventurer.id)/add-to-wishlist/\(adventure.id)") else {
               print("Invalid URL")
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"

           URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data, error == nil else {
                   print("Error: \(error?.localizedDescription ?? "Unknown error")")
                   return
               }

               if let httpResponse = response as? HTTPURLResponse {
                   if httpResponse.statusCode == 200 {
                       DispatchQueue.main.async {
                           // Update UI or handle success
                           self.isAddedToWishlist = true
                       }
                   } else {
                       print("HTTP Status Code: \(httpResponse.statusCode)")
                       // Handle error
                   }
               }
           }.resume()
       }
           }


#Preview {
    DetailedAdventureView(adventure: Adventure(id: 2, name: "String", description: "String", creatorName: "String"), viewModel: Connection())
}
