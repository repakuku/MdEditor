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
	private lazy var screen = TodoListScreenObject(app: app)

	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		app.launchArguments = [LaunchArguments.skipLogin.rawValue]

		app.launch()
	}

	// TODO: Change func name
	func test_sections_mustBeValid() {
		screen
			.isTodoListScreen()
			.checkSectionTitle(index: 0, title: L10n.TodoList.Section.uncompleted)
			.checkSectionTitle(index: 1, title: L10n.TodoList.Section.completed)
	}

	// TODO: Change func name
	func test_task_mustBeValid() {
		screen
			.isTodoListScreen()
			.checkCountOfSelectedItems(1)
			.checkCountOfNotSelectedItems(4)
			.checkCellTitle(section: 0, row: 0, title: L10n.Task.doHomework)
			.checkCellTitle(section: 0, row: 1, title: L10n.Task.goShopping)
			.checkCellTitle(section: 0, row: 2, title: L10n.Task.writeNewTasks)
			.checkCellTitle(section: 0, row: 3, title: L10n.Task.solve3Algorithms)
			.checkCellTitle(section: 1, row: 0, title: L10n.Task.doWorkout)
	}

	// TODO: Change func name
	func test_doTask_mustBeValid() {
		screen
			.isTodoListScreen()
			.tapOnCell(section: 0, row: 0)
			.checkCountOfSelectedItems(2)
			.checkCountOfNotSelectedItems(3)
			.checkCellTitle(section: 0, row: 0, title: L10n.Task.goShopping)
			.checkCellTitle(section: 0, row: 1, title: L10n.Task.writeNewTasks)
			.checkCellTitle(section: 0, row: 2, title: L10n.Task.solve3Algorithms)
			.checkCellTitle(section: 1, row: 0, title: L10n.Task.doHomework)
			.checkCellTitle(section: 1, row: 1, title: L10n.Task.doWorkout)
	}

	// TODO: Change func name
	func test_undoTask_mustBeValid() {
		screen
			.isTodoListScreen()
			.tapOnCell(section: 1, row: 0)
			.checkCountOfSelectedItems(2)
			.checkCountOfNotSelectedItems(3)
			.checkCellTitle(section: 0, row: 0, title: L10n.Task.doHomework)
			.checkCellTitle(section: 0, row: 1, title: L10n.Task.goShopping)
			.checkCellTitle(section: 0, row: 2, title: L10n.Task.writeNewTasks)
			.checkCellTitle(section: 0, row: 3, title: L10n.Task.doWorkout)
			.checkCellTitle(section: 0, row: 4, title: L10n.Task.solve3Algorithms)
	}
}
