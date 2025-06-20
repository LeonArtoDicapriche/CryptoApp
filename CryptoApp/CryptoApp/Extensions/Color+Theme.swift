import SwiftUI

extension Color {
    /// Return struct ColorTheme which contains the main colors of the application
    static let theme = ColorTheme()
    /// Return struct LaunchTheme which contains the main colors of the launch view
    static let launchTheme = LaunchTheme()
    
}

struct ColorTheme {
    let accent = Color(R.color.accentColor() ?? UIColor())
    let background = Color(R.color.backgroundColor() ?? UIColor())
    let green = Color(R.color.greenColor() ?? UIColor())
    let red = Color(R.color.redColor() ?? UIColor())
    let secondaryText = Color(R.color.secondarytextColor() ?? UIColor())
}

struct LaunchTheme {
    let accent = Color(R.color.launchAccentColor() ?? UIColor())
    let background = Color(R.color.launchBackgroundColor() ?? UIColor())
}
