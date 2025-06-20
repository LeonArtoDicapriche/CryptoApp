import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortfolio = false // animate right
    @State private var showPortfolioView = false // new sheet
    @State private var selectedCoin: Coin?
    @State private var showDetailView = false
    @State private var showSettingsView = false
    
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(viewModel)
                })
            
            // content layer
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                    .accessibilityIdentifier("HomeStatsView")
                SearchBarView(searchText: $viewModel.searchText)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
                            portfolioEmtyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                     .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
        }
        .background(
        NavigationLink(
            destination: DetailLoadingView(coin: $selectedCoin),
            isActive: $showDetailView,
            label: { EmptyView() })
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? .plus : .info)
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .accessibilityIdentifier("LeftHeaderButton")
                .background(
                CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: .chevronRight)
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
                .accessibilityIdentifier("rightHeaderButton")
        }
        .padding(.horizontal, 10)
    }
    
    private var allCoinsList: some View {
        ScrollView {
            PullToRefresh(coordinateSpaceName: .coordinateSpaceName,
                          isLoading: $viewModel.isLoading) {
                viewModel.reloadData()
            }
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .accessibilityIdentifier("Cell - \(coin.name ?? "")")
            }
            .padding(.trailing, 10)
        }
        .coordinateSpace(name: String.coordinateSpaceName)
    }
    
    private func segue(coin: Coin) {
       selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioEmtyText: some View {
        Text("You haven't added ant coin to your portfolio yet! Click the + button to get started. 🧐")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
          .multilineTextAlignment(.center)
          .padding(50)
    }
    
    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOptions == .rank || viewModel.sortOptions == .rankReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOptions == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortOptions = viewModel.sortOptions == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(viewModel.sortOptions == .holdings || viewModel.sortOptions == .holdingsReversed ? 1 : 0)
                        .rotationEffect(Angle(degrees: viewModel.sortOptions == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.sortOptions = viewModel.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack {
                Text("Price")
                    .frame(width: .width35, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOptions == .price || viewModel.sortOptions == .priceReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOptions == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortOptions = viewModel.sortOptions == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
}
