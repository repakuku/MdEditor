//
//  MainMenuCoordinator.swift
//  MdEdit
//
//  Created by ioskendev on 12.01.2024.
//

import UIKit
import TaskManagerPackage

final class MainCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let fileExplorer: IFileExplorer
	private let delegate: IFileManagerDelegate

	// MARK: - Internal properties

	var finishFlow: ((Screen) -> Void)?

	// MARK: - Initialization

	init(
		navigationController: UINavigationController,
		fileExplorer: IFileExplorer,
		delegate: IFileManagerDelegate
	) {
		self.navigationController = navigationController
		self.fileExplorer = fileExplorer
		self.delegate = delegate
	}

	// MARK: - Internal methods

	override func start() {
		showMainMenuScene()
	}
}

private extension MainCoordinator {
	func showMainMenuScene() {
		let assembler = MainMenuAssembler(fileExplorer: fileExplorer)
		let viewController = assembler.assembly { [weak self] nextScreen in
			self?.finishFlow?(nextScreen)
		}
		navigationController.pushViewController(viewController, animated: true)
	}

	func runAboutFlow() {
		let coordinator = AboutCoordinator(
			navigationController: navigationController,
			fileExplorer: fileExplorer
		)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			coordinator.map { self?.removeDependency($0) }
		}

		coordinator.start()
	}

	func runOpenFlow() {
		let coordinator = FileManagerCoordinator(
			navigationController: navigationController,
			fileExplorer: fileExplorer,
			delegate: delegate
		)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			coordinator.map { self?.removeDependency($0) }
		}

		coordinator.start()
	}
}
