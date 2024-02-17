//
//  AppCoordinator.swift
//  MdEditor
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
	private let fileExplorer: IFileExplorer
	private let delegate: IFileManagerDelegate

	// MARK: - Initialization

	init(
		window: UIWindow?,
		taskManager: ITaskManager,
		fileExplorer: IFileExplorer,
		delegate: IFileManagerDelegate
	) {
		self.window = window
		self.taskManager = taskManager
		self.navigationController = UINavigationController()
		self.fileExplorer = fileExplorer
		self.delegate = delegate
	}

	// MARK: - Internal methods

	override func start() {
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		runLoginFlow()
	}

	func runLoginFlow() {
		let coordinator = LoginCoordinator(navigationController: navigationController)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			guard let self else { return }
			self.runMainFlow()
			coordinator.map { self.removeDependency($0) }
			self.navigationController.viewControllers.removeFirst()
		}

		coordinator.start()
	}

	func runMainFlow() {
		let coordinator = MainCoordinator(
			navigationController: navigationController,
			fileExplorer: fileExplorer,
			delegate: delegate
		)
		addDependency(coordinator)
		coordinator.start()
	}
}

extension AppCoordinator: ITestCoordinator {
	func testStart(parameters: [LaunchArguments: Bool]) {
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()

		if let skipLogin = parameters[LaunchArguments.skipLogin], skipLogin {
			runMainFlow()
		} else {
			runLoginFlow()
		}
	}
}
