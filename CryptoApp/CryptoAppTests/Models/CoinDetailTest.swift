import XCTest
@testable import CryptoApp

class CoinDetailTest: XCTestCase {

    var coin: CoinDetail!
    
    override func setUpWithError() throws {
        coin = DeveloperPreview.instance.coinDetailMock
    }

    override func tearDownWithError() throws {
        coin = nil
    }

    func testExample() {
        guard let descriptionWithoutHTML = coin.descriptionWithoutHTML else {
            XCTFail("coin description is nil")
            return
        }
        XCTAssertFalse(descriptionWithoutHTML.contains("https"))
    }

}
