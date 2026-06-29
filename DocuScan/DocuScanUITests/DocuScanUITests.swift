import XCTest

final class DocuScanUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING", "-hasCompletedOnboarding", "true"]
        app.launch()
    }

    func testTabBarExists() throws {
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }

    func testToolsTabIsDefault() throws {
        let toolsTab = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(toolsTab.isSelected)
    }

    func testNavigateToRecent() throws {
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.navigationBars["Recent"].exists || app.staticTexts["Recent"].exists)
    }

    func testNavigateToSettings() throws {
        app.tabBars.buttons.element(boundBy: 3).tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists || app.staticTexts["Settings"].exists)
    }
}
