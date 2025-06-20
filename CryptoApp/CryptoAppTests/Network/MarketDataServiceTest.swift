import XCTest
@testable import CryptoApp

class MarketDataServiceTest: XCTestCase {

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
        let sampleGlobalData = DeveloperPreview.instance.globalDataMock
        let mockData = try JSONEncoder().encode(sampleGlobalData)
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let marketDataService = MarketDataService(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        
        marketDataService.getMarketData { marketData, _ in
            XCTAssertEqual(marketData?.volume, sampleGlobalData.data?.volume)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testEmptyURL() {
        let marketDataService = MarketDataService()
        marketDataService.getMarketData(url: "") { data, _ in
            XCTAssertNil(data)
        }
    }
    
    func testWrongURL() throws {
        let sampleGlobalData = DeveloperPreview.instance.globalDataMock
        let mockData = try JSONEncoder().encode([sampleGlobalData])
        
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        let marketDataService = MarketDataService(urlSession: urlSession)
        
        let expectation = XCTestExpectation(description: "response")
        
        marketDataService.getMarketData { _, result in
            XCTAssertEqual(result, "failure")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
