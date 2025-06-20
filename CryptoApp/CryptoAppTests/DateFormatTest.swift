import XCTest
@testable import CryptoApp

class DateFormatTest: XCTestCase {

    func testInit() {
        let testDate = "2021-08-18T07:22:21+0000"
        let date = Date(coinDate: testDate)
        XCTAssertNotEqual(date, Date())
    }
    
    func testInitWithWrongDate() {
        let testDate = ""
        let date = Date(coinDate: testDate).description
        let nowDate = Date().description
        XCTAssertEqual(date, nowDate)
    }
    
    func testShortFormatDate() {
        let testDate = Date()
        let dayComponents = Calendar.current.dateComponents([.month, .day, .year], from: testDate)
        let year = String(dayComponents.year ?? 0000).dropFirst().dropFirst()
        XCTAssertEqual(testDate.asShortDayString(), "\(dayComponents.month ?? 0)/\(dayComponents.day ?? 0)/" + year)
    }

}
