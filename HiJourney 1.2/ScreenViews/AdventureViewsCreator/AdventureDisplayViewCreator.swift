//
//  AdventureDisplayViewCreator.swift
//  HiJourney 1.2
//
//  Created by Ivayla  Panayotova on 15.02.24.
//


import SwiftUI

struct AdventureDisplayViewCreator: View {

    @StateObject var adventureFetcher = AdventureFetcher()
    @StateObject var viewModel: Connection
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(adventureFetcher.adventures) { adventure in
                        NavigationLink(destination: DetailedAdventureViewCreator(adventure: adventure, viewModel: viewModel, viewModelAdv: AttendedAdventuresVModel())) {
                            AdventureView(adventure: adventure)
                        }
                    }
                }
                .padding()
                .onAppear {
                    adventureFetcher.fetchData()
                }
            }
            .navigationBarTitle("Adventures")
        }
    }
}


#Preview {
    AdventureDisplayViewCreator(viewModel: Connection())
}
