import Foundation

extension Double {
    
    /// Converts a Double to Currency with 2 decimal pieces
    /// ```
    /// Convert 1234.45 to $1,234.56
    /// Convert 12.3445 to $12.35
    /// Convert 0.123445 to $0,12
    ///
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = .currencyCode
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts a Double to Currency with 2-6 decimal pieces
    /// ```
    /// Convert 1234.45 to $1,234.56
    ///
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = .currencyCode
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Converts a Double to Currency as a String with 2 decimal pieces
    /// ```
    /// Convert 1234.45 to "$1,234.56"
    /// ```
    /// - Returns: String
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double to Currency as a String with 2-6 decimal pieces
    /// ```
    /// Convert 1234.45 to "$1,234.56"
    /// Convert 12.3445 to "$12.3445"
    /// Convert 0.123445 to "$0.123445"
    /// ```
    /// - Returns: String
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Converts a Double into string representation
    /// ```
    /// Converts 1.2345 to "1.23"
    /// ```
    /// - Returns: String
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    // Converts a Double into string representation with percent symbol
    /// ```
    /// Converts 1.2345 to "1.23%"
    /// ```
    /// - Returns: String
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations
    /// ```
    /// convert 12 to 12.00
    /// convert 1234 to 1.23K
    /// convert 123456 to 123.46K
    /// convert 12345678 to 12.35M
    /// convert 1234567890 to 1.23Bn
    /// convert 123456789012 to 123.46Bn
    /// convert 12345678901234 to 12,35Tr
    /// ```
    /// - Returns: String
    func formattedWithAbbreviations() -> String {
        let num = abs(self)
        let sign = self < 0 ? "-" : ""
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return sign + stringFormatted + "Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return sign + stringFormatted + "Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return sign + stringFormatted + "M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return sign + stringFormatted + "K"
        case 0...:
            return sign + self.asNumberString()
        default:
            return sign + "\(self)"
        }
    }
}
// swiftlint:disable foundation_using
