// swiftlint:disable foundation_using
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var sortOptions: SortOption = .holdings
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancelables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancelables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancelables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalData)
            .sink { [weak self] stats in
                self?.statistic = stats
                self?.isLoading = false
            }
            .store(in: &cancelables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var fillteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &fillteredCoins)
        return fillteredCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else { return coins }
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            if let name = coin.name, let symbol = coin.symbol, let ident = coin.id {
                return
                    name.lowercased().contains(lowercasedText) ||
                    symbol.lowercased().contains(lowercasedText) ||
                    ident.lowercased().contains(lowercasedText)
            } else {
                return false
            }
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
             coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice ?? 0 > $1.currentPrice ?? 0 })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice ?? 0 < $1.currentPrice ?? 0 })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOptions {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue ?? 0 > $1.currentHoldingsValue ?? 0 })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue ?? 0 < $1.currentHoldingsValue ?? 0 })
        default:
            return coins
        }
        
    }
    
    private func mapGlobalData(data: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = data else { return stats }
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        stats.append(marketCap)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        stats.append(volume)
        let btcDominante = Statistic(title: "BTC Dominance", value: data.btcDominance)
        stats.append(btcDominante)
        let portFolioValue = portfolioCoins
            .compactMap({ $0.currentHoldingsValue })
            .reduce(0, +)
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue ?? 0
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        let percentageChange = ((portFolioValue + previousValue) / previousValue)
        let portfolio = Statistic(title: "Portfolio Value",
                                  value: portFolioValue.asCurrencyWith2Decimals(),
                                  percentageChange: percentageChange)
        stats.append(portfolio)
        return stats
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioCoins: [Portfolio]) -> [Coin] {
        allCoins
            .compactMap { (coin) -> Coin? in
                guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
}
// swiftlint:disable foundation_using
