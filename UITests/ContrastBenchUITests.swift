import XCTest

final class ContrastBenchUITests: XCTestCase {
  @MainActor
  func testValidationAndSwap() {
    let app = XCUIApplication()
    app.launch()
    let foreground = app.textFields["foreground"]
    XCTAssertTrue(foreground.waitForExistence(timeout: 10))
    let initial = app.staticTexts["ratio"].label
    app.buttons["swap"].tap()
    XCTAssertEqual(app.staticTexts["ratio"].label, initial)
    foreground.tap()
    foreground.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 16))
    foreground.typeText("INVALID")
    XCTAssertTrue(
      app.otherElements["invalidColor"].exists || app.staticTexts["invalidColor"].exists)
    XCTAssertFalse(app.staticTexts["ratio"].exists)
  }
}
