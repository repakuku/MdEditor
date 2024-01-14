//
//  TodoListCoordinator.swift
//  TodoList
//
//  Created by Alexey Turulin on 1/14/24.
//

import UIKit
import TaskManagerPackage

final class TodoListCoordinator: ICoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let taskManager: TaskManager

	// MARK: - Initialization

	init(navigationController: UINavigationController, taskManager: TaskManager) {
		self.navigationController = navigationController
		self.taskManager = taskManager
	}

	// MARK: - Internal methods

	func start() {
		showTodoListScene()
	}

	private func showTodoListScene() {
		let repository = TaskRepositoryStub()
		let orderedTaskManager = OrderedTaskManager(taskManager: taskManager)
		orderedTaskManager.addTasks(tasks: repository.getTasks())

		let assembler = TodoListAssembler(taskManager: orderedTaskManager)
		let viewController = assembler.assembly()
		navigationController.pushViewController(viewController, animated: true)
	}
}
