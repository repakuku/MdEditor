import XCTest
@testable import TaskManagerPackage

final class TaskTests: XCTestCase {

	func test_init_withTitle_shouldReturnCorrectTitle() {
		let sut = Task(title: "Task")

		XCTAssertEqual(sut.title, "Task")
	}

	func test_init_withTitleAndCompletedStatus_shouldReturnCompletedStatusTrue() {
		let sut = Task(title: "Task", completed: true)

		XCTAssertTrue(sut.completed)
	}
}
