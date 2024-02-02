//
//  TodoListScreenObject.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 1/20/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import XCTest
import TaskManagerPackage

final class TodoListScreenObject: BaseScreenObject {

	// MARK: - Private properties

	private lazy var navigationBar = app.navigationBars.firstMatch
	private lazy var navigationBarTitle = navigationBar.staticTexts.firstMatch

	private lazy var tableView = app.tables.element
//	private lazy var uncompletedSection = tableView.otherElements.staticTexts[L10n.TodoList.Section.uncompleted]
//	private lazy var completedSection = tableView.otherElements.staticTexts[L10n.TodoList.Section.completed]

	private var cell: XCUIElement! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - ScreenObject Methods

	@discardableResult
	func isTodoListScreen() -> Self {
		assert(navigationBarTitle, [.contains(L10n.TodoList.title)])

		return self
	}

	@discardableResult
	func getCell(indexPath: IndexPath) -> Self {
		let cell = tableView.cells[
			AccessibilityIdentifier.cell(section: indexPath.section, row: indexPath.row).description
		]

		assert(cell, [.exists])

		self.cell = cell

		return self
	}

	@discardableResult
	func tapCell() -> Self {
		tap(cell)
		return self
	}

	@discardableResult
	func checkSectionTitles() -> Self {

		let section0 = tableView.otherElements[AccessibilityIdentifier.section(index: 0).description]
		let section1 = tableView.otherElements[AccessibilityIdentifier.section(index: 1).description]

		assert(section0, [.exists])
		assert(section1, [.exists])

		XCTAssertEqual(section0.label, L10n.TodoList.Section.uncompleted)
		XCTAssertEqual(section1.label, L10n.TodoList.Section.completed)

		return self
	}

	@discardableResult
	func checkCellInfo(indexPath: IndexPath) -> Self {
		let cell = tableView.cells[
			AccessibilityIdentifier.cell(section: indexPath.section, row: indexPath.row).description
		]

		let taskTitle = cell.staticTexts.element(boundBy: 0).label
		let taskDeadline = cell.staticTexts.element(boundBy: 1).label

		XCTAssertEqual(taskTitle, L10n.Task.doHomework)

		return self
	}
//	
//	@discardableResult
//	func validTaskTitle(_ title: String) -> Self {
//		let cellTitle = getTaskTitle()
//
//		XCTAssertEqual(title, cellTitle)
//
//		return self
//	}
//
//	@discardableResult
//	func validTaskDeadline() -> Self {
//
//		let taskDeadline = getTaskDeadline()
//
//		XCTAssertTrue(taskDeadline.hasPrefix("Deadline"))
//
//		return self
//	}
//
//	@discardableResult
//	func validTaskStatus() -> Self {
//
//		let taskStatus = getTaskStatus()
//
//		XCTAssertEqual(taskStatus, "checkmark")
//
//		return self
//	}
//
//	private func getTaskTitle() -> String {
//		let title = cell.staticTexts.firstMatch
//
//		assert(title, [.exists])
//
//		return title.label
//	}
//
//	private func getTaskDeadline() -> String {
//		let deadline = cell.staticTexts.element(boundBy: 1)
//
//		assert(deadline, [.exists])
//
//		return deadline.label
//	}
//
//	private func getTaskStatus() -> String {
//		let status = cell.buttons.firstMatch
//
//		assert(status, [.exists])
//
//		return status.label
//	}
}
