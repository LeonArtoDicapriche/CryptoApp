import XCTest
@testable import CryptoApp

class DoubleExtensionTest: XCTestCase {

    func testAsCurrencyWith2Decimals() {
        let testNumber = [1234.45]
        let expectedResults = ["$1,234.45"]
        zip(testNumber, expectedResults).forEach({ XCTAssertEqual($0.asCurrencyWith2Decimals(), $1) })
    }
  
    func testAsCurrencyWith6Decimals() {
        let testNumbers = [1234.45, 12.3445, 0.123445]
        let expectedResults = ["$1,234.45", "$12.3445", "$0.123445"]
        zip(testNumbers, expectedResults).forEach({ XCTAssertEqual($0.asCurrencyWith6Decimals(), $1) })
    }
    
    func testAsNumberString() {
        let testNumber = 1.23445
        XCTAssertEqual(testNumber.asNumberString(), "1.23")
    }
    
    func testAsPercentString() {
        let testNumber = 1.23445
        XCTAssertEqual(testNumber.asPercentString(), "1.23%")
    }
    
    func testFormattedWithAbbreviations() {
        let testNumbers: [Double] = [12, 1234, 123456, 12345678, 1234567890, 123456789012, 12345678901234, 0, -1000, Double.nan]
        let expectedResults = ["12.00", "1.23K", "123.46K", "12.35M", "1.23Bn", "123.46Bn", "12.35Tr", "0.00", "-1.00K", "nan"]
        zip(testNumbers, expectedResults).forEach({ XCTAssertEqual($0.formattedWithAbbreviations(), $1) })
    }
}
