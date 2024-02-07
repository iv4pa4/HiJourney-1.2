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
    @ObservedObject var viewModel : AdventurerViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        
        NavigationView {
                   ScrollView {
                       LazyVGrid(columns: columns, spacing: 20) {
                           ForEach(viewModel.adventurers, id: \.id) { adventurer in
                               VStack(alignment: .leading) {
                                   Text("ID: \(adventurer.id)")
                                   Text("Username: \(adventurer.username)")
                                   Text("Email: \(adventurer.email)")
                               }
                               .padding()
                               .background(Color.gray.opacity(0.2)) // Optional styling
                               .cornerRadius(10)
                           }
                       }
                       .padding()
                   }
            .navigationBarTitle("Adventurers")
        }
    }
}

#Preview {
    AdventurerDisplayView(viewModel: AdventurerViewModel() )
}
