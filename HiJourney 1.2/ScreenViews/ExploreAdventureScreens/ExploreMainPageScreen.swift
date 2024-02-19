import SwiftUI

struct ExploreMainPageScreen: View {
    //TODO: Remove back tags !!!
    @State var currentTab: Tab = .Explore
    @ObservedObject var viewModel: Connection
    var iconFrame: CGFloat = 25
    var textPadding: CGFloat = 50

    init(viewModel: Connection) {
        UITabBar.appearance().isHidden = true
        self.viewModel = viewModel
    }

    @Namespace var animations

    var body: some View {
        
        
        TabView(selection: $currentTab) {
            AdventureDisplayView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Explore)
            
            WishlistAdventuresDisplayView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.WishList)

           
            AdventurerDisplayView(viewModel: AdventurerViewModel(), viewModelCon: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Add)

            ProfileView(adventurer: currentAdventurer)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Profile)

        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                }
                .padding(.vertical)
                .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                .background(Color("nav_bar_bg"))
            },
            alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }

    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName:  tab.rawValue )

                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: iconFrame, height: iconFrame)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(currentTab == tab ? .primary : .secondary)
                        .padding(currentTab == tab ? 15 : 0)
                        .background(
                            ZStack {
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "TAB", in: animations)

                                    Text(tab.tabName).foregroundColor(.primary).font(.footnote).padding(.top, textPadding)
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
    ExploreMainPageScreen(viewModel: Connection())
}

enum Tab: String, CaseIterable{
    case Explore = "house"
    case WishList = "heart"
    case Add = "figure.2"
    case Profile = "person"
    
    var tabName: String{
        switch self {
        case .Add:
            return "Meet"
        case .WishList:
            return "WishList"
        case .Explore:
            return "Explore"
        case .Profile:
            return "Profile"
        }
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else {
            return .zero
        }
        
        guard let SafeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return SafeArea
    }
}

struct MaterialEffect: UIViewRepresentable{
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) ->UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
