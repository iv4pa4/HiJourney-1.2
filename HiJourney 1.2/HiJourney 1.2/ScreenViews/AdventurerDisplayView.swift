import SwiftUI



class AdventurerViewModel: ObservableObject {
    @Published var adventurers: [Adventurer] = []

    init() {
        fetchData()
    }

    func fetchData() {
        guard let url = URL(string: "http://localhost:3001/adventurer") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON response: \(jsonString)")
            }

            do {
                let result = try JSONDecoder().decode(AdventurerResponse.self, from: data)
                DispatchQueue.main.async {
                    self.adventurers = result.items
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct AdventurerDisplayView: View {
    @ObservedObject var viewModel = AdventurerViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.adventurers) { adventurer in
                VStack(alignment: .leading) {
                    Text("ID: \(adventurer.id)")
                    Text("Username: \(adventurer.username)")
                    Text("Email: \(adventurer.email)")
                    Text("Attended Adventures: \(adventurer.attendedAdventuresCount)")
                }
            }
            .navigationBarTitle("Adventurers")
        }
    }
}

#Preview {
    AdventurerDisplayView(viewModel: AdventurerViewModel() )
}
