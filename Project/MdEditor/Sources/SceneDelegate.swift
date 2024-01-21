//
//  SceneDelegate.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/3/24.
//

import UIKit
import TaskManagerPackage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	private var appCoordinator: ICoordinator! // swiftlint:disable:this implicitly_unwrapped_optional

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)

		let repository = TaskRepositoryStub()
		let orderedTaskManager = OrderedTaskManager(taskManager: TaskManager())
		orderedTaskManager.addTasks(tasks: repository.getTasks())

		appCoordinator = AppCoordinator(window: window, taskManager: orderedTaskManager)
		appCoordinator.start()

		self.window = window
	}
}
