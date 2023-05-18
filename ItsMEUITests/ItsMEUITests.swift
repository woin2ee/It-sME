//
//  ItsMEUITests.swift
//  ItsMEUITests
//
//  Created by MacBook Air on 2022/11/07.
//

import XCTest

final class ItsMEUITests: XCTestCase {

    var app: XCUIApplication!
    
    var loginAlertHandlerToken: NSObjectProtocol!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        
        continueAfterFailure = false
        
        loginAlertHandlerToken = addUIInterruptionMonitor(withDescription: "Login Alert") { alert in
            alert.buttons["계속"].tap()
            return true
        }
    }
    
    override func tearDownWithError() throws {
        app = nil
        
        removeUIInterruptionMonitor(loginAlertHandlerToken)
    }
    
    func testUpdateName() {
        // Arrange: Values for test
        let newName = "홍길동"
        
        // Arrange: 앱 시작 후 프로필 수정화면 이동
        app.launchArguments = [
            "-TEST",
            "-TARGET_VIEW_CONTROLLER", "HOME_VIEW_CONTROLLER",
            "-AUTHENTICATION", "TRUE",
        ]
        app.launch()
        let editProfileButton = app.buttons["HOME__EDIT_PROFILE"]
        editProfileButton.tap()
        
        // Act: 이름 수정
        let nameTextField = app.textFields["PROFILE_EDITING__NAME_TEXT_FIELD"]
        nameTextField.tap()
        nameTextField.clearAndEnterText(text: newName)
        let doneButton = app.navigationBars["프로필 수정"].buttons["수정완료"]
        doneButton.tap()
        
        // Assert: 수정된 이름 확인
        XCTAssert(editProfileButton.waitForExistence(timeout: 10))
        editProfileButton.tap()
        XCTAssertEqual(nameTextField.value as! String, newName)
    }
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
