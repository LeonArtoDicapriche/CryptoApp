/*
 url: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 
 */

// swiftlint:disable identifier_name
struct CoinDetail: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let description: Description?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case description = "description"
        case links
    }
    
    var descriptionWithoutHTML: String? {
        return description?.en?.removingHTMLOccurences
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?

    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
// swiftlint:enable identifier_name
