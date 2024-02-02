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

	override func tearDown() {
		app.terminate()
		super.tearDown()
	}

	func test_sectionTitles_mustBeCorrect() {

		let sut = makeSUT()

		sut
			.isTodoListScreen()
			.checkSectionTitles()
	}

	func test_cellsInfo_mustBeCorrect() {

		let sut = makeSUT()
		let indexPath = IndexPath(row: 0, section: 0)

		sut
			.isTodoListScreen()
			.checkCellInfo(indexPath: indexPath)
	}
}

extension TodoListSceneUITests {
	private func makeSUT() -> TodoListScreenObject {
		let app = XCUIApplication()
		let screen = TodoListScreenObject(app: app)
		app.launchArguments.append("-skipLogin")
		app.launch()

		return screen
	}
}
