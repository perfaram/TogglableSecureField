//
//  TogglableSecureFieldDemoUITests.swift
//  TogglableSecureFieldDemoUITests
//
//  Created by pfaramaz on 09.12.21.
//

import XCTest

class TogglableSecureFieldDemoUITests: XCTestCase {
    
    let mockPassword = "p455!_w0rD"
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        app.launchEnvironment = ["UITEST_SHOW_PASSWORD" : "YES"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testVisibilityToggle() throws {
        // At first, the password is not visible, so MyTogglablePasswordField is still a secureTextField
        XCTAssert(app.secureTextFields["MyTogglablePasswordField"].exists)
        XCTAssert(!app.textFields["MyTogglablePasswordField"].exists)
        
        let togglableField = app.secureTextFields["MyTogglablePasswordField"]
        togglableField.tap()
        togglableField.typeText(mockPassword)
        togglableField.typeText(XCUIKeyboardKey.return.rawValue)
        
        // Then, we toggle password visibility
        let showButton = app.buttons["Show"]
        showButton.tap()
        
        // Now, MyTogglablePasswordField should be a regular textField
        XCTAssert(app.textFields["MyTogglablePasswordField"].exists)
        XCTAssert(!app.secureTextFields["MyTogglablePasswordField"].exists)
        
        // Finally, check that we can toggle it back to a secureTextField
        app.buttons["Hide"].tap()
        XCTAssert(app.secureTextFields["MyTogglablePasswordField"].exists)
        XCTAssert(!app.textFields["MyTogglablePasswordField"].exists)
    }
    
    func testSecureContentBinding() throws {
        let togglableField = app.secureTextFields["MyTogglablePasswordField"]
        togglableField.tap()
        togglableField.typeText(mockPassword)
        
        var textField = app.textFields["currentPassword"]
        if !textField.exists {
            // Our backing UITextField becomes a secure text field when the password
            // is not displayed in cleartext
            textField = app.secureTextFields["currentPassword"]
        }
        
        XCTAssertEqual(textField.value as! String, mockPassword)
    }
}
