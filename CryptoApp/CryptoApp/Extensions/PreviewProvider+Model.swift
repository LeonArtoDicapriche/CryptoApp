import SwiftUI

extension PreviewProvider {
    
    /// Return instance of class DeveloperPreview for mocking data in preview
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() { }
    
    let homeVM = HomeViewModel()
    
    let statMock1 = Statistic(title: "Market Cap", value: "$12.2Bn", percentageChange: 25.34)
    let statMock2 = Statistic(title: "Total Volume", value: "$1.23Tr")
    let statMock3 = Statistic(title: "Market Cap", value: "$12.2Bn", percentageChange: -25.34)
    
    var coinMock = Coin(id: "bitcoinMOCK",
                    symbol: "btc",
                    name: "Bitcoin",
                    image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                    currentPrice: 45378,
                    marketCap: 852418012154,
                    marketCapRank: 1,
                    fullyDilutedValuation: 952997860120,
                    totalVolume: 37972517140,
                    high24H: 46704,
                    low24H: 44941,
                    priceChange24H: -974.030208538592,
                    priceChangePercentage24H: -2.10139,
                    marketCapChange24H: -16899861504.101807,
                    marketCapChangePercentage24H: -1.94404,
                    circulatingSupply: 18783650.0,
                    totalSupply: 21000000.0,
                    maxSupply: 21000000.0,
                    ath: 64805,
                    athChangePercentage: -30.28133,
                    athDate: "2021-04-14T11:54:46.763Z",
                    atl: 67.81,
                    atlChangePercentage: 66529.78115,
                    atlDate: "2013-07-06T00:00:00.000Z",
                    lastUpdated: "2021-08-12T07:13:41.297Z",
                    sparklineIn7D: SparklineIn7D(price: [39367.72728223309,
                                                         39106.31020922284,
                                                         38857.427628298225,
                                                         38683.56672332221,
                                                         37954.52871122685,
                                                         38051.91976641489,
                                                         38097.24009234376,
                                                         37595.74682436388,
                                                         37964.91150820191,
                                                         39028.84376674017,
                                                         38824.02351506793,
                                                         39464.54104250195,
                                                         40580.98237542944,
                                                         40923.46578710913,
                                                         40663.25049633999,
                                                         40952.35080975313,
                                                         40844.89380017341,
                                                         40927.23410607631,
                                                         40825.381940449704,
                                                         39871.57156095284,
                                                         40652.49991439878,
                                                         40339.04352853331,
                                                         40126.3037557355,
                                                         40090.91071471639,
                                                         40665.275786599064,
                                                         40959.42840081205,
                                                         40926.654950362456,
                                                         41135.48184151653,
                                                         40665]),
                    priceChangePercentage24HInCurrency: -2.101386665838238,
                    currentHoldings: 0)
    // swiftlint:disable line_length
    let coinDetailMock = CoinDetail(id: "bitcoin",
                                    symbol: "btc",
                                    name: "Bitcoin",
                                    blockTimeInMinutes: 10,
                                    hashingAlgorithm: "SHA-256",
                                    categories: [],
                                    description: Description(en: "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the <a href=\"https://www.coingecko.com/en?hashing_algorithm=SHA-256\">SHA-256</a> hashing algorithm with an average transaction confirmation time of 10 minutes. Being the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as <a href=\"https://www.coingecko.com/en/coins/litecoin\">Litecoin</a>, <a href=\"https://www.coingecko.com/en/coins/peercoin\">Peercoin</a>, <a href=\"https://www.coingecko.com/en/coins/primecoin\">Primecoin</a>, and so on. The cryptocurrency then took off with the innovation of the turing-complete smart contract by <a href=\"https://www.coingecko.com/en/coins/ethereum\">Ethereum</a> which led to the development of other amazing projects such as <a href=\"https://www.coingecko.com/en/coins/eos\">EOS</a>, <a href=\"https://www.coingecko.com/en/coins/tron\">Tron</a>, and even crypto-collectibles such as <a href=\"https://www.coingecko.com/buzz/ethereum-still-king-dapps-cryptokitties-need-1-billion-on-eos\">CryptoKitties</a>."
                                    ),
                                    links: Links(homepage: ["http://www.bitcoin.org"], subredditURL: "https://www.reddit.com/r/Bitcoin/"))
    // swiftlint:enable line_length
    
    let marketDataMock = MarketData(totalMarketCap: [.currencyCode: 44405534.43002511],
                                totalVolume: [.currencyCode: 2573176.960971293],
                                marketCapPercentage: [.btc: 42.32504403165534],
                                marketCapChangePercentage24HUsd: 10)
    let globalDataMock = GlobalData(data: MarketData(totalMarketCap: [.currencyCode: 44405534.43002511],
                                                     totalVolume: [.currencyCode: 2573176.960971293],
                                                     marketCapPercentage: [.btc: 42.32504403165534],
                                                     marketCapChangePercentage24HUsd: 10))
}
