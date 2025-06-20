import XCTest
@testable import CryptoApp

final class CryptoAppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITestsDisableAnimations", "-UITestsWithoutLaunchScreen"]
        app.launch()
        sleep(3)
    }

    func testHomeScreenLabelsExist() throws {
        let titleLabel = app.staticTexts["Live prices"]
        XCTAssertTrue(titleLabel.exists)
        XCTAssertFalse(titleLabel.label.isEmpty)
    }

    func testSearchFiltersResultsCorrectly() throws {
        let searchTextF = app.textFields["SearchCoin"]
        
        searchTextF.tap()
        searchTextF.typeText("BNB")
        
        app.buttons["Return"].tap()
        
        let bnbLabel = app.staticTexts["BNB"]
        XCTAssert(bnbLabel.waitForExistence(timeout: 5))
        
        bnbLabel.tap()
        
        let titleLabel = app.staticTexts["Overview"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5))
    }
    
    func testAddCoinToPortfolio() throws {
        app/*@START_MENU_TOKEN@*/.images["rightHeaderButton"]/*[[".images[\"Forward\"]",".images[\"rightHeaderButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let titleLabel = app.staticTexts["Portfolio"]
        XCTAssertTrue(titleLabel.exists)
        
        let leftHeaderButton = app.images["LeftHeaderButton"]
        leftHeaderButton.tap()
        
        let searchTextF = app.textFields["SearchCoinForPortfolio"]
        
        searchTextF.tap()
        searchTextF.typeText("BNB")
        
        app.buttons["Return"].tap()
        
        let bnbCell = app.staticTexts["bnb"]
        XCTAssert(bnbCell.waitForExistence(timeout: 5))
        bnbCell.tap()
                
        let changeCoinTextF = app.textFields["ChangeCoin"]
        changeCoinTextF.tap()
        changeCoinTextF.typeText("10")
        
        app.buttons["SaveButton"].tap()
    }
}
