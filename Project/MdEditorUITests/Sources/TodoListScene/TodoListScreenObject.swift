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
	private lazy var uncompletedSection = tableView.otherElements.staticTexts["Uncompleted"]
	private lazy var completedSection = tableView.otherElements.staticTexts["Completed"]

	private var cell: XCUIElement! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - ScreenObject Methods

	@discardableResult
	func isTodoListScreen() -> Self {
		assert(navigationBarTitle, [.contains("Tasks")])

		return self
	}

	@discardableResult
	func getCell(indexPath: IndexPath) -> Self {
		let cell = tableView.cells["cell-\(indexPath.section)-\(indexPath.row)"]

		assert(cell, [.exists])

		self.cell = cell

		return self
	}

	@discardableResult
	func tapCell() -> Self {
		tap(cell, timeout: 10)
		return self
	}

	@discardableResult
	func validHeaderTitles() -> Self {

		let otherElements = tableView.otherElements.allElementsBoundByIndex
		let sections = otherElements.filter { $0.identifier.contains("section") }

		XCTAssertEqual(sections.count, 2, "Expected 2 sections, but found \(sections)")

		assert(uncompletedSection, [.exists])
		assert(completedSection, [.exists])

		return self
	}

	@discardableResult
	func validTaskTitle(_ title: String) -> Self {
		let cellTitle = getTaskTitle()

		XCTAssertEqual(title, cellTitle, "Task title should be equal the cell title.")

		return self
	}

	@discardableResult
	func validTaskDeadline() -> Self {

		let taskDeadline = getTaskDeadline()

		XCTAssertTrue(taskDeadline.hasPrefix("Deadline"))

		return self
	}

	@discardableResult
	func validTaskStatus() -> Self {

		let taskStatus = getTaskStatus()

		XCTAssertEqual(taskStatus, "checkmark")

		return self
	}

	private func getTaskTitle() -> String {
		let title = cell.staticTexts.firstMatch

		assert(title, [.exists])

		return title.label
	}

	private func getTaskDeadline() -> String {
		let deadline = cell.staticTexts.element(boundBy: 1)

		assert(deadline, [.exists])

		return deadline.label
	}

	private func getTaskStatus() -> String {
		let status = cell.buttons.firstMatch

		assert(status, [.exists])

		return status.label
	}
}
