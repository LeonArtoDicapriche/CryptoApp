import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistic: [Statistic] = []
    @Published var additionalStatistic: [Statistic] = []
    @Published var coin: Coin
    @Published var coinDescription: String?
    @Published var webSiteURL: String?
    @Published var redditURL: String?
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] retutnedArrays in
                self?.overviewStatistic = retutnedArrays.overview
                self?.additionalStatistic = retutnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] coinDetails in
                self?.coinDescription = coinDetails?.descriptionWithoutHTML
                self?.webSiteURL = coinDetails?.links?.homepage?.first
                self?.redditURL = coinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetails: CoinDetail?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        return (createOverviewArray(coin: coin), createAdditionalArray(coinDetails: coinDetails))
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        let price = (coin.currentPrice ?? 0).asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H ?? 0
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = String.currencySymbol + Double(coin.marketCap ?? 0).formattedWithAbbreviations()
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = String(coin.rank)
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = String.currencySymbol + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func createAdditionalArray(coinDetails: CoinDetail?) -> [Statistic] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? ""
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? ""
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coin.priceChangePercentage24H ?? 0
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = coin.marketCapChange24H?.formattedWithAbbreviations() ?? ""
        let marketCapPercentChange2 = coin.marketCapChangePercentage24H ?? 0
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetails?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetails?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
       return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
}
