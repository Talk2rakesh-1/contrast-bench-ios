import XCTest

final class ContrastBenchUITests: XCTestCase {
  @MainActor
  func testValidationAndSwap() {
    let app = XCUIApplication()
    app.launch()
    let foreground = app.textFields["foreground"]
    XCTAssertTrue(foreground.waitForExistence(timeout: 10))
    XCTAssertTrue(app.staticTexts["Foreground"].exists)
    XCTAssertTrue(app.staticTexts["Background"].exists)
    let screenshot = XCTAttachment(screenshot: app.screenshot())
    screenshot.name = "ContrastBench initial workbench"
    screenshot.lifetime = .keepAlways
    add(screenshot)
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
