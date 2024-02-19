import SwiftUI

struct AdventureSearchView: View {
    @State private var name: String = ""
    @State private var authToken: String = "" // Assuming you have a token
    @State private var adventures: [SearchAdventure] = []
    
    var body: some View {
        VStack {
            TextField("Enter keyword", text: $name)
                .padding()
            
            Button("Search") {
                searchAdventureByName(name: name)
                searchAdventureByDescription(desc: name)
            }
            .frame(width: 128, height: 45)
            .foregroundColor(.black)
            .background(Color("BlueForButtons"))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .font(.custom("Poppins-Bold", size:15))
            .shadow(color: .black, radius: 4, x: 3, y: 4)
            
            List(adventures, id: \.id) { adventure in
                SearchView(adventure: adventure)
            }
        }
    }
    
    func searchAdventureByName(name: String) {
        guard let url = URL(string: "http://localhost:3001/adventure/search/\(name)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let data = data {
                do {
                    let decodedAdventures = try JSONDecoder().decode([SearchAdventure].self, from: data)
                    DispatchQueue.main.async {
                        self.adventures = decodedAdventures
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func searchAdventureByDescription(desc: String) {
        guard let url = URL(string: "http://localhost:3001/adventure/search/description/\(desc)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let data = data {
                do {
                    let decodedAdventures = try JSONDecoder().decode([SearchAdventure].self, from: data)
                    DispatchQueue.main.async {
                        self.adventures = decodedAdventures
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

struct AdventureSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureSearchView()
    }
}
