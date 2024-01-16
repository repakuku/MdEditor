//
//  SomeTest.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest

final class SomeTestCase: XCTestCase {
	
	override func setUp() {
		let app = XCUIApplication()

		// Два типа, как мы можем влиять на наше приложение.

		// Аргументы
		app.launchArguments = ["-enableTesting"]
		
		// Окружение
		app.launchEnvironment = ["serverURL":"Swiftbook.ru"]
		
		app.launch()
	}

	func testMethod1() {
		
	}
}
