//
//  TodoListSceneUITests.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 1/20/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
import TaskManagerPackage

final class TodoListSceneUITests: XCTestCase {

	private let app = XCUIApplication()

	override class func setUp() {
		let app = XCUIApplication()

		app.launchArguments = [LaunchArguments.enableTesting.rawValue]
		app.launchArguments = ["-AppleLanguages", "(en)"]
	}

	override func setUp() {
		super.setUp()
		app.launch()

		login()
	}

	override func tearDown() {
		app.terminate()
		super.tearDown()
	}

	func test_headerTitles_mustBeCorrect() {

		let todoListScreen = TodoListScreenObject(app: app)

		todoListScreen
			.isTodoListScreen()
			.validHeaderTitles()
	}

	func test_uncomplitedTaskInfo_mustBeCorrect() {

		let todoListScreen = TodoListScreenObject(app: app)
		let indexPath = IndexPath(row: 0, section: 0)

		todoListScreen
			.isTodoListScreen()
			.getCell(indexPath: indexPath)
			.validTaskTitle("!!! Do homework")
			.validTaskDeadline()
	}

	func test_complitedTaskInfo_mustBeCorrect() {

		let todoListScreen = TodoListScreenObject(app: app)
		let indexPath = IndexPath(row: 0, section: 1)

		todoListScreen
			.isTodoListScreen()
			.getCell(indexPath: indexPath)
			.validTaskTitle("Do workout")
			.validTaskStatus()
	}

	func test_tapTask_statusShouldBeChanged() {

		let todoListScreen = TodoListScreenObject(app: app)
		let uncomplitedIndexPath = IndexPath(row: 0, section: 0)
		let complitedIndexPath = IndexPath(row: 0, section: 1)

		todoListScreen
			.isTodoListScreen()
			.getCell(indexPath: uncomplitedIndexPath)
			.validTaskTitle("!!! Do homework")
			.tapCell()
			.getCell(indexPath: complitedIndexPath)
			.validTaskTitle("!!! Do homework")
	}
}

extension TodoListSceneUITests {
	private func login() {
		let loginScreen = LoginScreenObject(app: app)

		loginScreen
			.isLoginScreen()
			.set(login: "Admin")
			.set(password: "pa$$32!")
			.login()
	}
}
