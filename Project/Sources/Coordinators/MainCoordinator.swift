//
//  MainMenuCoordinator.swift
//  MdEdit
//
//  Created by ioskendev on 12.01.2024.
//

import UIKit
import TaskManagerPackage
import MarkdownPackage

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
		let allert = UIAlertController(title: L10n.Message.text, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: L10n.Ok.text, style: .default)
		allert.addAction(okAction)
		navigationController.present(allert, animated: true)
	}

	func showMainMenuScene() {
		let assembler = MainMenuAssembler()
		let viewController = assembler.assembly(recentFileManager: recentFileManager, delegate: self)
		viewController.navigationItem.setHidesBackButton(true, animated: true)

		navigationController.pushViewController(viewController, animated: true)
	}

	func showTodoListScene(text: String) {
		let taskManager = TaskManager()

		let document = MarkdownToDocument().convert(markdownText: text)
		let taskRepository: ITaskRepository = TaskScanner(document: document)

		taskManager.addTasks(tasks: taskRepository.getTasks())

		let assembler = TodoListAssembler()
		let viewController = assembler.assembly(
			taskManager: OrderedTaskManager(taskManager: taskManager),
			createTaskClosure: nil
		)

		navigationController.present(viewController, animated: true)
	}

	func showTextEditorScene(file: File, searchText: String? = nil) {
		let assembler = TextEditorAssembler()
		let viewController = assembler.assembly(file: file, searchText: searchText, delegate: self)

		navigationController.pushViewController(viewController, animated: true)
	}

	func showPdfPreviewScene(file: File) {
		let assembler = PdfPreviewAssembler()
		let viewController = assembler.assembly(file: file)

		navigationController.pushViewController(viewController, animated: true)
	}

	func showSearchManager() {
		let assembler = SearchManagerAssembler()
		let viewController = assembler.assembly(delegate: self)

		navigationController.pushViewController(viewController, animated: true)
	}

	func showTagManager() {
		let assembler = TagManagerAssembler()
		let viewController = assembler.assembly(delegate: self)

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
		showMessage(message: L10n.MainMenu.newFile)
	}

	func startSearch() {
		showSearchManager()
	}

	func showTags() {
		showTagManager()
	}
}

// MARK: - ITextEditorDelegate

extension MainCoordinator: ITextEditorDelegate {
	func openTodoList(text: String) {
		showTodoListScene(text: text)
	}
}

// MARK: - ISearchManagerDelegate

extension MainCoordinator: ISearchManagerDelegate {
	func openFile(file: File, searchText: String) {
		showTextEditorScene(file: file, searchText: searchText)
	}
}

// MARK: - ITagmanagerDelegate

extension MainCoordinator: ITagManagerDelegate { }
