//
//  SomeTest.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest

final class SomeTestCase: XCTestCase {
	
	private let app = XCUIApplication()
	
	override func setUp() {
		let app = XCUIApplication()

		app.launchArguments = [LaunchArguments.enableTesting.rawValue]
		app.launchArguments = ["-AppleLanguages", "(en)"]

		app.launch()
	}

	func testLoginWithInvalidCredentials() throws {

		let usernameTextField = app.textFields[AccessibilityIdentifier.textFieldLogin.rawValue]
		let passwordTextField = app.secureTextFields[AccessibilityIdentifier.textFieldPass.rawValue]
		let loginButton = app.buttons[AccessibilityIdentifier.buttonLogin.rawValue]
		
		usernameTextField.tap()
		usernameTextField.typeText("invalidUsername")
		
		passwordTextField.tap()
		passwordTextField.typeText("invalidPassword")
		
		loginButton.tap()

		// TODO: It doesn't work
		addUIInterruptionMonitor(withDescription: "Invalid Credentials") { alert -> Bool in
			let errorMessage = alert.staticTexts["Wrong login or password"]
			XCTAssertTrue(errorMessage.exists, "Expected error message not found.")
			let okButton = alert.buttons["Ok"]
			okButton.tap()
			return true
		}

		XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))

		XCTAssertTrue(usernameTextField.exists)
		XCTAssertTrue(passwordTextField.exists)
		XCTAssertTrue(loginButton.exists)
	}
}
