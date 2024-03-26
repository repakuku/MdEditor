//
//  MainMenuCoordinator.swift
//  MdEdit
//
//  Created by ioskendev on 12.01.2024.
//

import UIKit
import TaskManagerPackage
import MarkdownPackage
import NetworkPackage

final class MainCoordinator: BaseCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let recentFileManager = StubRecentFileManager()

	// MARK: - Initialization

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods

	override func start() {
		showMainMenuScene()
	}
}

// MARK: - Private methods

private extension MainCoordinator {

	func showMessage(message: String) {
	}

	func showMainMenuScene() {
		let assembler = MainMenuAssembler(recentFileManager: recentFileManager)
		let (viewController, interactor) = assembler.assembly()
		viewController.navigationItem.setHidesBackButton(true, animated: true)
		interactor.delegate = self

		navigationController.pushViewController(viewController, animated: true)
	}

	func showTodoListScene(text: String) {
		let taskManager = TaskManager()

		let document = MarkdownToDocument().convert(markdownText: text)
		let taskRepository: ITaskRepository = TaskScanner(document: document)

		taskManager.addTasks(tasks: taskRepository.getTasks())

		let assembler = TodoListAssembler(taskManager: OrderedTaskManager(taskManager: taskManager))
		let viewController = assembler.assembly(createTaskClosure: nil)

		navigationController.present(viewController, animated: true)
	}

	func showTextEditorScene(file: File) {
		let assembler = TextEditorAssembler(file: file)
		let (viewController, interactor) = assembler.assembly()
		interactor.delegate = self

		navigationController.pushViewController(viewController, animated: true)
	}

	func showPdfPreviewScene(file: File) {
		let assembler = PdfPreviewAssembler(file: file)
		let (viewController, _) = assembler.assembly()

		navigationController.pushViewController(viewController, animated: true)
	}

	func runFileManagerFlow() {
		let topViewController = navigationController.topViewController
		let coordinator = FileManagerCoordinator(
			navigationController: navigationController,
			topViewController: topViewController
		)
		addDependency(coordinator)

		coordinator.finishFlow = { [weak self, weak coordinator] in
			guard let self = self else { return }
			if let topViewController = topViewController {
				self.navigationController.popToViewController(topViewController, animated: true)
			} else {
				self.navigationController.popToRootViewController(animated: true)
			}
			if let coordinator = coordinator {
				self.removeDependency(coordinator)
			}
		}

		coordinator.start()
	}
}

// MARK: - IMainMenuDelegate

extension MainCoordinator: IMainMenuDelegate {

	func showAbout() {
		switch File.parse(url: Endpoints.documentAbout) {
		case .success(let aboutFile):
			showPdfPreviewScene(file: aboutFile)
		case .failure:
			break
		}
	}

	func openFileExplorer() {
		runFileManagerFlow()
	}

	func openFile(file: File) {
		showTextEditorScene(file: file)
	}

	func newFile() {

		let authService = AuthService()

		authService.perform { result in
			switch result {
			case .success(let response):
				let token = response.access_token
				print("Token: \(token)")
			case .failure(let error):
				print(error)
			}
		}
		showMessage(message: "")
	}
}

// MARK: - ITextEditorDelegate

extension MainCoordinator: ITextEditorDelegate {
	func openTodoList(text: String) {
		showTodoListScene(text: text)
	}
}
