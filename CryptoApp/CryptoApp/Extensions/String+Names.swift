extension String {
    // icons
    static let chevronRight = "chevron.right"
    static let info = "info"
    static let plus = "plus"
    
    // currency code
    static let currencyCode = "usd"
    static let currencySymbol = "$"
    static let btc = "btc"
    
    // url
    static let apiURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    static let apiMarketURL = "https://api.coingecko.com/api/v3/global"
    static var apiDetailURLFirst = "https://api.coingecko.com/api/v3/coins/"
    static let apiDetailURLSecond = "?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    
    // folder name
    static let folderName = "coin_images"
    
    // CoreData
    
    static let containerName = "PortfolioContainer"
    static let entityName = "Portfolio"
    
    // coordinate Space name
    static let coordinateSpaceName = "pullToRefresh"
}
