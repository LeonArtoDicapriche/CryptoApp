import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                List {
                    firstSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    secondSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    appSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
            }
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.light)
    }
}

extension SettingsView {
    private var firstSection: some View {
        Section(header: Text("About")) {
            HStack(alignment: .top, spacing: 20) {
                Image(uiImage: R.image.logo() ?? UIImage())
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This is a test project. It uses MVVM Architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
        }
    }
    
    private var secondSection: some View {
        Section(header: Text("CoinGeko")) {
            VStack(alignment: .leading) {
                Image(uiImage: R.image.coingecko() ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                // swiftlint:disable line_length
                Text("CoinGecko provides a fundamental analysis of the crypto market. In addition to tracking price, volume and market capitalization, CoinGecko tracks community growth, open-source code development, major events and on-chain metrics.")
                    // swiftlint:enable line_length
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            if let url = URL(string: "https://www.coingecko.com/") {
                Link("Visit CoinGeko", destination: url)
            }
        }
    }
    
    private var appSection: some View {
        Section(header: Text("Application")) {
            if let url = URL(string: "https://google.com") {
                HStack {
                    Image(uiImage: R.image.termsOfUse() ?? UIImage())
                    Link("Terms of Use", destination: url)
                }
                HStack {
                    Image(uiImage: R.image.privacyPolicy() ?? UIImage())
                    Link("Privacy Policy", destination: url)
                }
                HStack {
                    Image(uiImage: R.image.contactUS() ?? UIImage())
                    Link("Contact Us", destination: url)
                }
                HStack {
                    Image(uiImage: R.image.learnMore() ?? UIImage())
                    Link("Learn More", destination: url)
                }
            }
        }
    }
}
