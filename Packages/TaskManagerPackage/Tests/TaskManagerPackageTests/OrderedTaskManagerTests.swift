//
//  OrderedTaskManagerTests.swift
//
//
//  Created by Alexey Turulin on 1/13/24.
//

import XCTest
@testable import TaskManagerPackage

final class OrderedTaskManagerTests: XCTestCase {

	func test_allTasks_shouldBe5TaskOrderedByPriority() {
		let sut = makeSUT()

		let validResultTasks: [TaskManagerPackage.Task] = [
			MockTaskManager.highImportantTask,
			MockTaskManager.mediumImportantTask,
			MockTaskManager.lowImportantTask,
			MockTaskManager.completedRegularTask,
			MockTaskManager.uncompletedRegularTask
		]

		let resultTasks = sut.allTasks()

		XCTAssertEqual(resultTasks.count, 5, "")
		XCTAssertEqual(resultTasks, validResultTasks, "")
	}

	func test_completedTasks_shouldBeAllCompletedTaskOrderedByPriority() {
		let sut = makeSUT()

		let validResultTasks: [TaskManagerPackage.Task] = [MockTaskManager.completedRegularTask]

		let resultTasks = sut.completedTasks()

		XCTAssertEqual(resultTasks.count, 1, "")
		XCTAssertEqual(resultTasks, validResultTasks, "")
	}

	func test_uncompletedTasks_shouldBeAllUncompletedTaskOrderedByPriority() {
		let sut = makeSUT()

		let validResultTasks: [TaskManagerPackage.Task] = [
			MockTaskManager.highImportantTask,
			MockTaskManager.mediumImportantTask,
			MockTaskManager.lowImportantTask,
			MockTaskManager.uncompletedRegularTask

		]

		let resultTasks = sut.uncompletedTasks()

		XCTAssertEqual(resultTasks.count, 4, "")
		XCTAssertEqual(resultTasks, validResultTasks, "")
	}
}

private extension OrderedTaskManagerTests {
	func makeSUT() -> OrderedTaskManager {
		let mockTaskManager = MockTaskManager()
		let sut = OrderedTaskManager(taskManager: mockTaskManager)
		return sut
	}
}
