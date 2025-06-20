import Foundation

extension Date {
    
    private var shorFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    /// Custom initilizer of struct Date from string
    /// - Parameter coinDate: string returned drom api call
    init(coinDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinDate) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    /// Returns string from date in short format
    /// - Returns: String
    func asShortDayString() -> String {
        return shorFormatter.string(from: self)
    }
}
// swiftlint:enable foundation_using
