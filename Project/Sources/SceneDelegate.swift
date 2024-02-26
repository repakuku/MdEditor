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

	private var appCoordinator: AppCoordinator! // swiftlint:disable:this implicitly_unwrapped_optional

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		window.makeKeyAndVisible()

		let navigationController = UINavigationController()

		appCoordinator = AppCoordinator(router: navigationController)

		window.rootViewController = navigationController
		self.window = window

		appCoordinator.start()
	}
}
