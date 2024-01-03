import XCTest
@testable import TaskManagerPackage

final class TaskManagerTests: XCTestCase {

	func test_init_withTaskList_shouldReturnCorrectTitle() {
		let title = "Task"
		let taskList = [Task(title: title)]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.allTasks()[0].title, title)
	}

	func test_allTasks_shouldReturnOneTask() {
		let taskList = [Task(title: "Task")]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.allTasks().count, 1)
	}

	func test_completedTasks_shouldReturnCompletedStatusTrue() {

		let taskList = [
			Task(title: "Completed Task", completed: true),
			Task(title: "Uncompleted Task", completed: false)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertTrue(sut.completedTasks()[0].completed)
	}

	func test_completedTasks_shouldReturnOneCompletedTask() {
		let taskList = [
			Task(title: "Completed Task", completed: true),
			Task(title: "Uncompleted Task", completed: false)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.completedTasks().count, 1)
	}

	func test_completedTasks_withUncompletedTask_ShouldReturn0() {
		let taskList = [
			Task(title: "Uncompleted Task", completed: false)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.completedTasks().count, 0)
	}

	func test_uncompletedTasks_shouldReturnCompletedStatusFalse() {

		let taskList = [
			Task(title: "Completed Task", completed: true),
			Task(title: "Uncompleted Task", completed: false)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertFalse(sut.uncompletedTasks()[0].completed)
	}

	func test_ucompletedTasks_shouldReturnOneUncompletedTask() {
		let taskList = [
			Task(title: "Completed Task", completed: true),
			Task(title: "Uncompleted Task", completed: false)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.uncompletedTasks().count, 1)
	}

	func test_uncompletedTasks_withCompletedTask_ShouldReturn0() {
		let taskList = [
			Task(title: "Completed Task", completed: true)
		]

		let sut = TaskManager(taskList: taskList)

		XCTAssertEqual(sut.uncompletedTasks().count, 0)
	}

	func test_addTask_shouldReturnCorrecTitle() {
		let title = "Task"
		let task = Task(title: title)

		let sut = TaskManager()

		sut.addTask(task: task)

		XCTAssertEqual(sut.allTasks()[0].title, title)
	}

	func test_addTasks_shouldReturn2() {
		let tasks = [
			Task(title: "Task1"),
			Task(title: "Task2")
		]

		let sut = TaskManager()

		sut.addTasks(tasks: tasks)

		XCTAssertEqual(sut.allTasks().count, 2)
	}

	func test_removeTask_shouldReturn0() {
		let task = Task(title: "Task")

		let sut = TaskManager(taskList: [task])

		sut.removeTask(task: task)

		XCTAssertEqual(sut.allTasks().count, 0)
	}
}
