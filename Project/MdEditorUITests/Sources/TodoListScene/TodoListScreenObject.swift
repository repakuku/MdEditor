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

	// MARK: - ScreenObject Methods

	@discardableResult
	func isTodoListScreen() -> Self {
		assert(navigationBarTitle, [.contains("ToDoList")])

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
	func getTaskTitle(section: Int, row: Int) -> Self {
		let cell = tableView.cells["cell-\(section)-\(row)"]
		let title = cell.staticTexts[cellTitles[section][row]]

		assert(cell, [.exists])
		assert(title, [.exists])

		return self
	}
}

extension TodoListScreenObject {

	private var cellTitles: [[String]] {
		[
			[
				"!!! Do homework",
				"!! Go shopping",
				"! Write new tasks",
				"Solve 3 algorithms"
			],
			[
				"Do Workout"
			]
		]
	}
}
