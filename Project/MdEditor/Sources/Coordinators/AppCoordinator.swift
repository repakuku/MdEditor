//
//  AppCoordinator.swift
//  TodoList
//
//  Created by Alexey Turulin on 1/14/24.
//

import UIKit
import TaskManagerPackage

final class AppCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private var window: UIWindow?
	private let taskManager: ITaskManager

	// MARK: - Initialization

	init(window: UIWindow?, taskManager: ITaskManager) {
		self.window = window
		self.taskManager = taskManager
		self.navigationController = UINavigationController()
	}
	
	// MARK: - Internal methods

	override func start() {
		runLoginFlow()
	}

	func runLoginFlow() {
		let coordinator = LoginCoordinator(navigationController: navigationController) 
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			self?.runTodoListFlow()
			coordinator.map { self?.removeDependency($0) }
		}

		coordinator.start()

		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	func runTodoListFlow() {
		let coordinator = TodoListCoordinator(
			navigationController: navigationController,
			taskManager: taskManager
		)
		addDependency(coordinator)

		coordinator.start()
	}
}
