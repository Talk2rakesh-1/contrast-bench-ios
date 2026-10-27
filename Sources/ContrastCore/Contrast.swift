import Foundation

public enum ColorError: Error, Equatable { case invalidHex }

/// Opaque 8-bit sRGB only. Alpha, wide gamut, and HDR are intentionally excluded.
public struct RGB: Equatable, Sendable {
  public let red: Double
  public let green: Double
  public let blue: Double
  public let hex: String

  public init(hex: String) throws {
    let value = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    let digits = value.hasPrefix("#") ? String(value.dropFirst()) : value
    guard digits.utf8.count == 6,
      digits.utf8.allSatisfy({
        (48...57).contains($0) || (65...70).contains($0) || (97...102).contains($0)
      }), let number = UInt32(digits, radix: 16)
    else { throw ColorError.invalidHex }
    self.hex = "#" + digits.uppercased()
    red = Double((number >> 16) & 255) / 255
    green = Double((number >> 8) & 255) / 255
    blue = Double(number & 255) / 255
  }

  public var luminance: Double {
    func linear(_ channel: Double) -> Double {
      channel <= 0.04045 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4)
    }
    return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
  }
}

public struct ContrastResult: Sendable {
  public let foreground: RGB
  public let background: RGB
  public init(foreground: RGB, background: RGB) {
    self.foreground = foreground
    self.background = background
  }
  public var ratio: Double {
    (max(foreground.luminance, background.luminance) + 0.05)
      / (min(foreground.luminance, background.luminance) + 0.05)
  }
  // Compare full precision; displayed rounding must never determine a pass.
  public var normalAA: Bool { ratio >= 4.5 }
  public var largeAA: Bool { ratio >= 3 }
  public var normalAAA: Bool { ratio >= 7 }
  public var largeAAA: Bool { ratio >= 4.5 }
  public var report: String {
    """
    ContrastBench — opaque sRGB color-pair report
    Foreground: \(foreground.hex); background: \(background.hex)
    Contrast: \(String(format: "%.4f", ratio)):1 (display rounded)
    AA normal text (4.5:1): \(normalAA ? "Pass" : "Fail")
    AA large text (3:1): \(largeAA ? "Pass" : "Fail")
    AAA normal text (7:1): \(normalAAA ? "Pass" : "Fail")
    AAA large text (4.5:1): \(largeAAA ? "Pass" : "Fail")
    Decisions use unrounded values. This is not an accessibility certification.
    Large text: at least 18pt regular or 14pt bold in WCAG's web definition.
    Source: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
    """
  }
}
