import XCTest
@testable import CryptoApp

class MarketDataTest: XCTestCase {

    var marketData: MarketData!
    
    override func setUpWithError() throws {
        marketData = DeveloperPreview.instance.marketDataMock
    }

    override func tearDownWithError() throws {
        marketData = nil
    }

    func testMarketCap() {
        XCTAssertFalse(marketData.marketCap.isEmpty)
        marketData.totalMarketCap?.removeAll()
        marketData.totalMarketCap = [.btc: 123]
        XCTAssertTrue(marketData.marketCap.isEmpty)
    }
    
    func testVolume() {
        XCTAssertFalse(marketData.volume.isEmpty)
        marketData.totalVolume?.removeAll()
        marketData.totalVolume = [.btc: 123]
        XCTAssertTrue(marketData.volume.isEmpty)
    }
    
    func testBtcDominance() {
        XCTAssertFalse(marketData.btcDominance.isEmpty)
        marketData.marketCapPercentage?.removeAll()
        marketData.marketCapPercentage = [.currencyCode: 123]
        XCTAssertTrue(marketData.btcDominance.isEmpty)
    }
}
