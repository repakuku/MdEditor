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

	private lazy var tableView = app.tables[AccessibilityIdentifier.TodoListScene.table.description]

	// MARK: - ScreenObject Methods

	@discardableResult
	func isTodoListScreen() -> Self {
		checkTitle(contains: L10n.TodoList.title)
		assert(tableView, [.exists])

		return self
	}

	@discardableResult
	func checkSectionTitle(index: Int, title: String) -> Self {

		return self
	}

	@discardableResult
	func tapOnCell(section: Int, row: Int) -> Self {

		return self
	}

	@discardableResult
	func checkCountOfSelectedItems(_ count: Int) -> Self {

		return self
	}

	@discardableResult
	func checkCountOfNotSelectedItems(_ count: Int) -> Self {

		return self
	}

	@discardableResult
	func checkCellTitle(section: Int, row: Int, title: String) -> Self {

		return self
	}
}
