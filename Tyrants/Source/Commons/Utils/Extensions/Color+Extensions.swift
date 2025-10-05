import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let r, g, b: Double
        switch hexString.count {
        case 6: // RGB (sem alpha)
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        default:
            r = 0; g = 0; b = 0
        }

        self.init(red: r, green: g, blue: b, opacity: opacity)
    }
}

struct HexColor: View {
    let hex: String
    let opacity: Double

    init(_ hex: String, opacity: Double = 1.0) {
        self.hex = hex
        self.opacity = opacity
    }

    var body: some View {
        Color(hex: hex, opacity: opacity)
            .ignoresSafeArea()
    }
}
