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

	private var repository = TaskRepositoryStub()
	private var taskManager: ITaskManager! // swiftlint:disable:this implicitly_unwrapped_optional
	private var fileExplorer: IFileExplorer! // swiftlint:disable:this implicitly_unwrapped_optional
	private var delegate: IFileManagerDelegate! // swiftlint:disable:this implicitly_unwrapped_optional
	private var appCoordinator: AppCoordinator! // swiftlint:disable:this implicitly_unwrapped_optional

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)

		taskManager = OrderedTaskManager(taskManager: TaskManager())
		taskManager.addTasks(tasks: repository.getTasks())
		fileExplorer = FileExplorer()

		appCoordinator = AppCoordinator(
			window: window,
			taskManager: taskManager,
			fileExplorer: fileExplorer,
			delegate: delegate
		)

#if DEBUG
		let parameters = LaunchArguments.parameters()
		if let enableTesting = parameters[LaunchArguments.enableTesting], enableTesting {
			UIView.setAnimationsEnabled(false)
		}
		appCoordinator.testStart(parameters: parameters)
#else
		appCoordinator.start()
#endif
		self.window = window
	}
}
