import XCTest
@testable import CryptoApp

class CoinImageServiceTest: XCTestCase {
    
    var urlSession: URLSession!
    var filemanager: LocalFileManager!
    
    override func setUpWithError() throws {
        filemanager = LocalFileManager.instance
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        urlSession = nil
        filemanager = nil
    }
    
    func testWrongUrl() throws {
        var sampleCoin = DeveloperPreview.instance.coinMock
        sampleCoin.image = ""
        let coinImageService = CoinImageService(coin: sampleCoin)
        coinImageService.getCoinImage { _, string in
            XCTAssertEqual(string, "error")
        }
    }
    
    func testDownloadImage() throws {
        let sampleCoin = DeveloperPreview.instance.coinMock
        guard let data = R.image.coingecko()?.pngData() else {
            XCTFail("no mock data")
            return
        }
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
        let coinImageService = CoinImageService(coin: sampleCoin, urlSession: urlSession)
        try deleteFileIfExist(fileName: sampleCoin.id)
        let expectation = XCTestExpectation(description: "response")
        
        coinImageService.getCoinImage { image, _ in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testEpmtyID() {
        var sampleCoin = DeveloperPreview.instance.coinMock
        sampleCoin.id = nil
        let coinImageService = CoinImageService(coin: sampleCoin)
        coinImageService.getCoinImage { _, string in
            XCTAssertEqual(string, "emptyID")
        }
    }
    
    func testWrongImageURL() throws {
        var sampleCoin = DeveloperPreview.instance.coinMock
        try deleteFileIfExist(fileName: sampleCoin.id)
        sampleCoin.image = nil
        let coinImageService = CoinImageService(coin: sampleCoin)
        coinImageService.getCoinImage { _, string in
            XCTAssertEqual(string, "error")
        }
    }
    
    func testCancelingSubscriber() throws {
        let sampleCoin = DeveloperPreview.instance.coinMock
        let data = Data()
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
        let coinImageService = CoinImageService(coin: sampleCoin, urlSession: urlSession)
        try deleteFileIfExist(fileName: sampleCoin.id)
        let expectation = XCTestExpectation(description: "response")
        
        coinImageService.getCoinImage { _, string in
            
            XCTAssertEqual(string, "finished")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30)
    }
    
    func testSavingImages() throws {
        let sampleCoin = DeveloperPreview.instance.coinMock
        guard let data = R.image.coingecko()?.pngData() else {
            XCTFail("no mock data")
            return
        }
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), data)
        }
        let coinImageService = CoinImageService(coin: sampleCoin, urlSession: urlSession)
        try deleteFileIfExist(fileName: sampleCoin.id)
        let expectation = XCTestExpectation(description: "response")
        
        coinImageService.getCoinImage { [weak self] _, _ in
            guard let self = self else {
                XCTFail("self not exist")
                return
            }
            XCTAssertTrue(self.checkFileExisting(fileName: sampleCoin.id).bool)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func deleteFileIfExist(fileName: String?) throws {
        let file = checkFileExisting(fileName: fileName)
        guard let url = file.url else { return }
        if file.bool {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    private func checkFileExisting(fileName: String?) -> (bool: Bool, url: URL?) {
        if let url = filemanager.getURLForImage(imageName: fileName ?? "", folderName: .folderName),
           FileManager.default.fileExists(atPath: url.path) {
            return (true, url)
        } else {
            return (false, nil)
        }
    }
}
