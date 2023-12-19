import SwiftUI

struct ExploreMainPageScreen: View {
    @State var currentTab: Tab = .Explore

    init() {
        UITabBar.appearance().isHidden = true
    }

    @Namespace var animations

    var body: some View {
        TabView(selection: $currentTab) {
            Text("Add View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Add)

            Text("WishList View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.WishList)

            Text("Explore View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Explore)

            Text("Profile View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea()) // Change "primaryColor" to your primary color
                .tag(Tab.Profile)

            Text("Notifications View")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("primaryColor").ignoresSafeArea())
                .tag(Tab.Notifications)
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
    }

    func TabButton(tab: Tab) -> some View {
        GeometryReader { proxy in
            Button(action: {
                withAnimation(.spring()) {
                    currentTab = tab
                }
            }, label: {
                VStack(spacing: 0) {
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill" : tab.rawValue)

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
    ExploreMainPageScreen()
}

enum Tab: String, CaseIterable{
    case Add = "plus.app"
    case WishList = "heart"
    case Explore = "house"
    case Notifications = "bell"
    case Profile = "person"
    
    var tabName: String{
        switch self {
        case .Add:
            return "Add"
        case .WishList:
            return "WishList"
        case .Explore:
            return "Explore"
        case .Notifications:
            return "Notifications"
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
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //
    }
}
