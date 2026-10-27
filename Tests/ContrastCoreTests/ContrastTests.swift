import Testing

@testable import ContrastCore

@Test func extremes() throws {
  let result = try pair("000000", "FFFFFF")
  #expect(abs(result.ratio - 21) < 0.000001)
  #expect(result.normalAAA)
}
@Test func identical() throws { #expect(try pair("123456", "123456").ratio == 1) }
@Test func symmetry() throws {
  #expect(try pair("123456", "ABCDEF").ratio == pair("ABCDEF", "123456").ratio)
}
@Test func normalization() throws { #expect(try RGB(hex: "  #abcdef\n").hex == "#ABCDEF") }
@Test(arguments: ["", "#FFF", "GGGGGG", "12345678", "１２３４５６", "0x1234", "##123456"])
func invalid(value: String) { #expect(throws: ColorError.invalidHex) { try RGB(hex: value) } }
@Test func thresholdsDoNotRound() throws {
  #expect(try !pair("777777", "FFFFFF").normalAA)
  #expect(try pair("767676", "FFFFFF").normalAA)
  #expect(try pair("777777", "FFFFFF").largeAA)
}
@Test func knownLuminance() throws {
  #expect(abs(try RGB(hex: "FF0000").luminance - 0.2126) < 0.000001)
  #expect(abs(try RGB(hex: "0A0A0A").luminance - (10.0 / 255 / 12.92)) < 0.000001)
}
@Test func report() throws {
  #expect(try pair("000000", "FFFFFF").report.contains("21.0000:1"))
  #expect(try pair("000000", "FFFFFF").report.contains("not an accessibility certification"))
}
private func pair(_ a: String, _ b: String) throws -> ContrastResult {
  try ContrastResult(foreground: RGB(hex: a), background: RGB(hex: b))
}
