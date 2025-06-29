// Coin Api
/*
 url: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 */

struct Coin: Codable, Identifiable {
    // swiftlint:disable identifier_name
    var id: String?
    let symbol, name: String?
    var image: String?
    var currentPrice: Double?
    let marketCap: Int?
    var marketCapRank: Int?
    let fullyDilutedValuation: Int?
    let totalVolume, high24H, low24H, priceChange24H: Double?
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    var currentHoldings: Double?
    
    var currentHoldingsValue: Double? {
        return currentPrice == nil ? nil : (currentHoldings ?? 0) * currentPrice!
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
            case id, symbol, name, image
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case marketCapRank = "market_cap_rank"
            case fullyDilutedValuation = "fully_diluted_valuation"
            case totalVolume = "total_volume"
            case high24H = "high_24h"
            case low24H = "low_24h"
            case priceChange24H = "price_change_24h"
            case priceChangePercentage24H = "price_change_percentage_24h"
            case marketCapChange24H = "market_cap_change_24h"
            case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
            case circulatingSupply = "circulating_supply"
            case totalSupply = "total_supply"
            case maxSupply = "max_supply"
            case ath
            case athChangePercentage = "ath_change_percentage"
            case athDate = "ath_date"
            case atl
            case atlChangePercentage = "atl_change_percentage"
            case atlDate = "atl_date"
            case lastUpdated = "last_updated"
            case sparklineIn7D = "sparkline_in_7d"
            case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
            case currentHoldings
        }
    // swiftlint:enable identifier_name
    
    func updateHoldings(amount: Double) -> Coin {
        Coin(id: id,
             symbol: symbol,
             name: name,
             image: image,
             currentPrice: currentPrice,
             marketCap: marketCap,
             marketCapRank: marketCapRank,
             fullyDilutedValuation: fullyDilutedValuation,
             totalVolume: totalVolume,
             high24H: high24H,
             low24H: low24H,
             priceChange24H: priceChange24H,
             priceChangePercentage24H: priceChangePercentage24H,
             marketCapChange24H: marketCapChange24H,
             marketCapChangePercentage24H: marketCapChangePercentage24H,
             circulatingSupply: circulatingSupply,
             totalSupply: totalSupply,
             maxSupply: maxSupply,
             ath: ath,
             athChangePercentage: athChangePercentage,
             athDate: athDate,
             atl: atl,
             atlChangePercentage: atlChangePercentage,
             atlDate: atlDate,
             lastUpdated: lastUpdated,
             sparklineIn7D: sparklineIn7D,
             priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
             currentHoldings: amount)
    }
}

// MARK: - SparklineIn7D

struct SparklineIn7D: Codable {
    let price: [Double]?
}
