import SwiftUI

class AdventureViewModel: ObservableObject {
    @Published var adventures: [Adventure] = []

    init() {
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: "http://localhost:3001/adventure") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let adventures = try JSONDecoder().decode([Adventure].self, from: data)
                DispatchQueue.main.async {
                    self.adventures = adventures
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}


struct AdventureDisplayView: View {
    @ObservedObject var viewModel = AdventureViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.adventures) { adventure in
                VStack(alignment: .leading) {
                    Text("Name: \(adventure.name)")
                    Text("Description: \(adventure.description)")
                    ForEach(adventure.creators, id: \.id) { creator in
                        Text("Creator: \(creator.name)")
                    }
                }
            }
            .navigationBarTitle("Adventures")
        }
    }
}


#Preview {
    AdventureDisplayView()
}
