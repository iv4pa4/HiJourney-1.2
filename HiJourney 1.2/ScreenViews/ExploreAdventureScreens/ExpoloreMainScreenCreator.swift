import SwiftUI

struct ExploreMainScreenCreator: View {
    //TODO: Remove back tags !!!
    @State var currentTab: TabCreator = .Explore
    @ObservedObject var viewModel: Connection

    init(viewModel: Connection) {
        UITabBar.appearance().isHidden = true
        self.viewModel = viewModel
    }

    @Namespace var animations

    var body: some View {
        
        TabView(selection: $currentTab) {
            AdventureDisplayViewCreator(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(TabCreator.Explore)
            
            CreateNewAdventureView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(TabCreator.Add)

            AdventurerDisplayView(viewModel: AdventurerViewModel(), viewModelCon: viewModel)
            AdventureSearchView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(TabCreator.Search)

            ProfileViewCreator(creator: currentCreator)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea()) // Change "primaryColor" to your primary color
                .tag(TabCreator.Profile)

        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(TabCreator.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                .background(Color("BlueForButtons"))
            },
            alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }

    func TabButton(tab: TabCreator) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName: tab.rawValue)

                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(currentTab == tab ? .primary : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animations)

                                    Text(tab.tabName).foregroundColor(.primary).font(.footnote).padding(.top, 50)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -35 : 0)
                }
            })
        }
        .frame(height: 25)
    }
}

#Preview {
    ExploreMainScreenCreator(viewModel: Connection())
}

enum TabCreator: String, CaseIterable{
    case Explore = "house"
    case Add = "plus"
    case Search = "magnifyingglass"
    case Profile = "person"
    
    var tabName: String{
        switch self {
        case .Explore:
            return "Explore"
        case .Add:
            return "Add"
        case .Search:
            return "Search"
        case .Profile:
            return "Profile"
        }
    }

}
