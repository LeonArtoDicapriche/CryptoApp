import XCTest
@testable import CryptoApp

class CoinTest: XCTestCase {
    var coin: Coin!

    override func setUpWithError() throws {
        coin = DeveloperPreview.instance.coinMock
    }

    override func tearDownWithError() throws {
        coin = nil
    }

    func testCoinRank() {
        coin.marketCapRank = 100
        XCTAssertEqual(coin.marketCapRank, coin.rank)
        coin.marketCapRank = nil
        XCTAssertEqual(0, coin.rank)
    }
    
    func testUpdateHoldings() {
        let holdings: Double = 16
        let newCoin = coin.updateHoldings(amount: holdings)
        XCTAssertEqual(holdings, newCoin.currentHoldings)
    }
    
    func testCurrentHoldingsValue() {
        var newCoin = coin.updateHoldings(amount: 120)
        let price = newCoin.currentPrice ?? 0
        let holdings = newCoin.currentHoldings ?? 0
        XCTAssertEqual(newCoin.currentHoldingsValue, price * holdings)
        newCoin.currentHoldings = nil
        XCTAssertEqual(newCoin.currentHoldingsValue, 0)
        newCoin.currentPrice = nil
        XCTAssertNil(newCoin.currentHoldingsValue)
        
    }

}
