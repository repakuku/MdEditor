//
//  SomeTest.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest

final class LoginSceneUITests: XCTestCase {

	private let app = XCUIApplication()

	override class func setUp() {
		let app = XCUIApplication()

		app.launchArguments = [LaunchArguments.enableTesting.rawValue]
		app.launchArguments = ["-AppleLanguages", "(en)"]
	}

	override func setUp() {
		super.setUp()
		app.launch()
	}

	override func tearDown() {
		app.terminate()
		super.tearDown()
	}

	func test_login_withInvalidCredentials_mustBeFailure() {

		let loginScreen = LoginScreenObject(app: app)

		loginScreen
			.isLoginScreen()
			.set(login: "invalidUsername")
			.set(password: "invalidUsername")
			.login()

//		let usernameTextField = app.textFields[AccessibilityIdentifier.textFieldLogin.rawValue]
//		let passwordTextField = app.secureTextFields[AccessibilityIdentifier.textFieldPass.rawValue]
//		let loginButton = app.buttons[AccessibilityIdentifier.buttonLogin.rawValue]
//		let alertButton = app.buttons[AccessibilityIdentifier.buttonAlert.rawValue]
//
//		usernameTextField.tap()
//		usernameTextField.typeText("invalidUsername")
//
//		passwordTextField.tap()
//		passwordTextField.typeText("invalidPassword")
//
//		loginButton.tap()
//
//		let errorMessage = app.alerts.staticTexts["Wrong login or password"]
//		XCTAssertTrue(errorMessage.exists, "Error message should appear for invalid credentials.")
//
//		// Dismiss the alert
//		alertButton.tap()
//
//		XCTAssertTrue(usernameTextField.exists, "Expected username text field on the same screen not found.")
//		XCTAssertTrue(passwordTextField.exists, "Expected password text field on the same screen not found.")
//		XCTAssertTrue(loginButton.exists, "Expected login button on the same screen not found.")
	}

	func test_login_withInvalidCredentials_mustBeSuccess() {
//
//		let usernameTextField = app.textFields[AccessibilityIdentifier.textFieldLogin.rawValue]
//		let passwordTextField = app.secureTextFields[AccessibilityIdentifier.textFieldPass.rawValue]
//		let loginButton = app.buttons[AccessibilityIdentifier.buttonLogin.rawValue]
//
//		usernameTextField.tap()
//		usernameTextField.typeText("Admin")
//
//		passwordTextField.tap()
//		passwordTextField.typeText("pa$$32!")
//
//		loginButton.tap()
//
//		let errorMessage = app.alerts.staticTexts["Wrong login or password"]
//		XCTAssertFalse(errorMessage.exists, "Error message should not appear for valid credentials.")
//
//		let tableView = app.tables[AccessibilityIdentifier.tableView.rawValue]
//
//		XCTAssertTrue(tableView.exists, "Expected table view on the next screen not found.")
	}
}
