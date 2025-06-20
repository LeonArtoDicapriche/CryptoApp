import XCTest
@testable import CryptoApp

class StringRemovingHTMLTest: XCTestCase {
// swiftlint:disable line_length
    let inputStrings = [
        "Bitcoin uses the <a href=\"https://www.coingecko.com/en?hashing_algorithm=SHA-256\">SHA-256</a> hashing algorithm with an average transaction confirmation time of 10 minutes.",
        "Being the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as <a href=\"https://www.coingecko.com/en/coins/litecoin\">Litecoin</a>, <a href=\"https://www.coingecko.com/en/coins/peercoin\">Peercoin</a>, <a href=\"https://www.coingecko.com/en/coins/primecoin\">Primecoin</a>, and so on.",
        "The cryptocurrency then took off with the innovation of the turing-complete smart contract by <a href=\"https://www.coingecko.com/en/coins/ethereum\">Ethereum</a> which led to the development of other amazing projects such as <a href=\"https://www.coingecko.com/en/coins/eos\">EOS</a>, <a href=\"https://www.coingecko.com/en/coins/tron\">Tron</a>, and even crypto-collectibles such as <a href=\"https://www.coingecko.com/buzz/ethereum-still-king-dapps-cryptokitties-need-1-billion-on-eos\">CryptoKitties</a>."
    ]
    
    let expectedStrings = [
        "Bitcoin uses the SHA-256 hashing algorithm with an average transaction confirmation time of 10 minutes.",
        "Being the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as Litecoin, Peercoin, Primecoin, and so on.",
        "The cryptocurrency then took off with the innovation of the turing-complete smart contract by Ethereum which led to the development of other amazing projects such as EOS, Tron, and even crypto-collectibles such as CryptoKitties."
    ]
// swiftlint:enable line_length

    func testRemovingHTMLOccurences() {
        zip(inputStrings, expectedStrings).forEach({ XCTAssertEqual($0.removingHTMLOccurences, $1) })
    }
}
