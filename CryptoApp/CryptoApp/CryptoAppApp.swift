import SwiftUI

@main
struct CryptoAppApp: App {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLaunchView = true
    
    init() {
        setAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(viewModel)
                .onAppear {
                    if CommandLine.arguments.contains("-UITestsDisableAnimations"),
                       CommandLine.arguments.contains("-UITestsWithoutLaunchScreen") {
                        UIView.setAnimationsEnabled(false)
                        showLaunchView = false
                    }
                }
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
            }
            
        }
    }
    
    private func setAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(.theme.accent)
        UITableView.appearance().backgroundColor = .clear
    }
}
