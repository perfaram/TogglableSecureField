import XCTest
@testable import TogglableSecureField

final class TogglableSecureFieldTests: XCTestCase {
    func testLoginButton() throws {
        let app = XCUIApplication()
        app.launch()
     
        let login = app.buttons["Login"]
        
        let view = TogglableSecureField_Previews.previews
        XCUI
     
        XCTAssert(login.exists)
    }
}
