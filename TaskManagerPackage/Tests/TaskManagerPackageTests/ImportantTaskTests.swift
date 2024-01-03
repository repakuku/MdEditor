import XCTest
import Foundation
@testable import TaskManagerPackage

final class ImportantTaskTests: XCTestCase {

	func test_init_withTitleAndtaskPriority_shouldReturnCorrectTitleAndPriority() {
		let sut = makeSUT()

		XCTAssertEqual(sut.title, "Task")
		XCTAssertEqual(sut.taskPriority, .low)
	}

	func test_deadline_withLowPriority_shouldReturnTodayPlus3Days() {
		let deadline = Calendar.current.date(byAdding: .day, value: 3, to: Date())!

		let sut = makeSUT()
		sut.taskPriority = .low

		XCTAssertEqual(sut.deadLine.description, deadline.description)
	}

	func test_deadline_withMediumPriority_shouldReturnTodayPlus2Days() {
		let deadline = Calendar.current.date(byAdding: .day, value: 2, to: Date())!

		let sut = makeSUT()
		sut.taskPriority = .medium

		XCTAssertEqual(sut.deadLine.description, deadline.description)
	}

	func test_deadline_withHighPriority_shouldReturnTodayPlus1Day() {
		let deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

		let sut = makeSUT()
		sut.taskPriority = .high

		XCTAssertEqual(sut.deadLine.description, deadline.description)
	}
}

extension ImportantTaskTests {
	func makeSUT() -> ImportantTask {
		let task = ImportantTask(title: "Task", taskPriority: .low)
		return task
	}
}
