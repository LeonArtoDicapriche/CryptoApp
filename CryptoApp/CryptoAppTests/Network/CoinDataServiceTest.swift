import XCTest
@testable import CryptoApp

class CoinDataServiceTest: XCTestCase {
    
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
        let sampleCoinData = DeveloperPreview.instance.coinMock
        let mockData = try JSONEncoder().encode([sampleCoinData])
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let coinDataService = CoinDataService(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        
        coinDataService.getCoins { coins, _ in
            XCTAssertEqual(coins?[0].name, "Bitcoin")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testEmptyURL() {
        let coinDataService = CoinDataService()
        coinDataService.getCoins(url: "") { coins, _  in
            XCTAssertNil(coins)
        }
    }
    
    func testWrongURL() throws {
        let sampleCoinData = DeveloperPreview.instance.coinMock
        let mockData = try JSONEncoder().encode(sampleCoinData)
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let coinDataService = CoinDataService(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        
        coinDataService.getCoins { _, result in
            XCTAssertEqual(result, "failure")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
