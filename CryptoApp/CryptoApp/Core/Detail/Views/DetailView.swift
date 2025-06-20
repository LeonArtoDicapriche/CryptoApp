import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    @State private var showFullDescription = false
    private let colums: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(viewModel.coin.name ?? "")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coinMock)
        }
        .preferredColorScheme(.dark)
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: colums,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
                    ForEach(viewModel.overviewStatistic) { stat in
                        StatisticView(stat: stat)
                    }
                  })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: colums,
                  alignment: .leading,
                  spacing: spacing,
                  pinnedViews: [],
                  content: {
                    ForEach(viewModel.additionalStatistic) { stat in
                        StatisticView(stat: stat)
                    }
                  })
    }
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(viewModel.coin.symbol ?? "")
                .accessibilityIdentifier("BarTrailingItem \(viewModel.coin.symbol)")
                .font(.headline)
                .foregroundColor(.theme.accent)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Read less..." : "Read more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let websiteString = viewModel.webSiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            if let redditString = viewModel.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accentColor(.blue)
        .font(.headline)
    }
}
