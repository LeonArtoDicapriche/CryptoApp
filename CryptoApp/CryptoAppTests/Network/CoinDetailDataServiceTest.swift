import XCTest
@testable import CryptoApp

class CoinDetailDataServiceTest: XCTestCase {

    var urlSession: URLSession!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        urlSession = nil
    }
    
    func testApiCall() throws {
        let sampleCoinDetail = DeveloperPreview.instance.coinDetailMock
        let mockData = try JSONEncoder().encode(sampleCoinDetail)
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let coinDetailDataService = CoinDetailDataService(coin: DeveloperPreview.instance.coinMock, urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        coinDetailDataService.getCoinDetails { coinDetail, _ in
            XCTAssertEqual(coinDetail?.descriptionWithoutHTML, sampleCoinDetail.descriptionWithoutHTML)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testWrongData() throws {
        let sampleCoinDetail = DeveloperPreview.instance.coinDetailMock
        let mockData = try JSONEncoder().encode([sampleCoinDetail])
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let coinDetailDataService = CoinDetailDataService(coin: DeveloperPreview.instance.coinMock, urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        coinDetailDataService.getCoinDetails { _, result in
            XCTAssertEqual(result, "failure")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testEmptyURLAndWrongID() {
        var coin = DeveloperPreview.instance.coinMock
        let coinDetailDataService = CoinDetailDataService(coin: coin)
        let savedString = String.apiDetailURLFirst
        String.apiDetailURLFirst = "http:\\"
        coinDetailDataService.getCoinDetails { coinDetail, _ in
            XCTAssertNil(coinDetail)
        }
        coin.id = nil
        coinDetailDataService.getCoinDetails { coinDetail, _ in
            XCTAssertNil(coinDetail)
        }
        String.apiDetailURLFirst = savedString
    }

}
