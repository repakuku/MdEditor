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

	// MARK: - Internal properties

	var finishFlow: ((Screen) -> Void)?

	// MARK: - Initialization

	init(
		navigationController: UINavigationController,
		fileExplorer: IFileExplorer
	) {
		self.navigationController = navigationController
		self.fileExplorer = fileExplorer
	}

	// MARK: - Internal methods

	override func start() {
		showMainMenuScene()
	}
}

private extension MainCoordinator {

	func showMainMenuScene() {
		let assembler = MainMenuAssembler(delegate: self)
		let viewController = assembler.assembly()
		viewController.navigationItem.setHidesBackButton(true, animated: true)
		navigationController.pushViewController(viewController, animated: true)
	}

	func showTextPreviewScene(file: File) {
		let assembler = TextPreviewAssembler(file: file)
		let viewController = assembler.assembly()
		navigationController.pushViewController(viewController, animated: true)
	}

	func runFileManagerFlow() {
		let coordinator: IFileManagerCoordinator = FileManagerCoordinator(
			navigationController: navigationController,
			fileExplorer: fileExplorer
		)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] file in
			guard let self = self, let coordinator = coordinator else { return }

			self.removeDependency(coordinator)
			self.navigationController.popToRootViewController(animated: true)

			if let file = file {
				self.showTextPreviewScene(file: file)
			}
		}

		coordinator.start()
	}
}

// MARK: - IMainMenuDelegate

extension MainCoordinator: IMainMenuDelegate {

	func showAbout() {
		let aboutUrl = Bundle.main.url(
			forResource: L10n.aboutFileName,
			withExtension: "md"
		)! // swiftlint:disable:this force_unwrapping
		switch File.parse(url: aboutUrl) {
		case .success(let aboutFile):
			showTextPreviewScene(file: aboutFile)
		case .failure:
			break
		}
	}

	func openFile() {
		runFileManagerFlow()
	}

	func openFile(file: File) {
		showTextPreviewScene(file: file)
	}

	func newFile() {}
}
