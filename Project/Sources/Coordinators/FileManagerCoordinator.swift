//
//  FileManagerCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import TaskManagerPackage
import MarkdownPackage

protocol IFileManagerCoordinator: ICoordinator {
	var finishFlow: (() -> Void)? { get set }
}

final class FileManagerCoordinator: NSObject, IFileManagerCoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private var topViewController: UIViewController?

	private let fileExplorer = FileExplorer()

	// MARK: - Internal properties

	var finishFlow: (() -> Void)?

	// MARK: - Initialization

	init(
		navigationController: UINavigationController,
		topViewController: UIViewController?
	) {
		self.navigationController = navigationController
		self.topViewController = topViewController

		super.init()

		navigationController.delegate = self
	}

	// MARK: - Internal methods

	func start() {
		showFileManagerScene(file: nil)
	}
}

// MARK: - Private methods

private extension FileManagerCoordinator {

	func showFileManagerScene(file: File?) {
		let assembler = FileManagerAssembler()
		let viewController = assembler.assembly(fileExplorer: fileExplorer, file: file, delegate: self)

		navigationController.pushViewController(viewController, animated: true)
	}

	func showTextEditorScene(file: File) {
		let assembler = TextEditorAssembler()
		let viewController = assembler.assembly(file: file, delegate: self)

		navigationController.pushViewController(viewController, animated: true)
	}

	private func showTodoListScene(text: String) {
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
}

// MARK: - UINavigationControllerDelegate

extension FileManagerCoordinator: UINavigationControllerDelegate {

	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		if viewController === topViewController {
			finishFlow?()
		}
	}
}

// MARK: - IFileManagerDelegate

extension FileManagerCoordinator: IFileManagerDelegate {
	func openFolder(file: File) {
		showFileManagerScene(file: file)
	}

	func openFile(file: File) {
		showTextEditorScene(file: file)
	}
}

// MARK: - ITextEditorDelegate

extension FileManagerCoordinator: ITextEditorDelegate {
	func openTodoList(text: String) {
		showTodoListScene(text: text)
	}
}
