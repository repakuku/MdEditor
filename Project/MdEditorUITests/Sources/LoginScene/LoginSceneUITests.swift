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
			.set(login: LoginCredentials.invalid.login)
			.set(password: LoginCredentials.invalid.password)
			.login()
			.invalidAttempt()
	}

	func test_login_withValidCredentials_mustBeSuccess() {

		let loginScreen = LoginScreenObject(app: app)

		loginScreen
			.isLoginScreen()
			.set(login: LoginCredentials.valid.login)
			.set(password: LoginCredentials.valid.password)
			.login()
			.validAttempt()
	}
}

private enum LoginCredentials {
	static let valid: (login: String, password: String) = ("Admin", "pa$$32!")
	static let invalid: (login: String, password: String) = ("invalidUsername", "invalidPassword")
}
