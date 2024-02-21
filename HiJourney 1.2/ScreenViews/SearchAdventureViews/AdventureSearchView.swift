import SwiftUI

struct AdventureSearchView: View {
    @State private var name: String = ""
    @State private var authToken: String = ""
    @ObservedObject var adventureProps : AdventureFetcher
    
    
    var body: some View {
        VStack {
            TextField("Enter keyword", text: $name)
                .padding()
            
            Button("Search") {
                adventureProps.searchAdventureByName(name: name)
                adventureProps.searchAdventureByDescription(desc: name)
                
                
            }
            .frame(width: 128, height: 45)
            .foregroundColor(.black)
            .background(Color("BlueForButtons"))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .font(.custom("Poppins-Bold", size:15))
            .shadow(color: .black, radius: 4, x: 3, y: 4)
            
            List(adventureProps.foundAdventures, id: \.id) { adventure in
                SearchView(adventure: adventure)
            }
        }
    }
    
}

struct AdventureSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AdventureSearchView(adventureProps: AdventureFetcher())
    }
}
