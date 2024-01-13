//
//  SceneDelegate.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = UIViewController()
		window?.makeKeyAndVisible()
	}
}
