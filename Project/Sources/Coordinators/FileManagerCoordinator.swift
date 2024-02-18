//
//  FileManagerCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol IFileManagerCoordinator: ICoordinator {
	var finishFlow: ((File?) -> Void)? { get set }
}

final class FileManagerCoordinator: NSObject, IFileManagerCoordinator, UINavigationControllerDelegate {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private var topViewController: UIViewController?

	private let fileExplorer: IFileExplorer

	// MARK: - Internal properties

	var finishFlow: ((File?) -> Void)?

	// MARK: - Initialization

	init(
		navigationController: UINavigationController,
		fileExplorer: IFileExplorer
	) {
		self.navigationController = navigationController
		self.fileExplorer = fileExplorer

		super.init()

		if let topViewController = navigationController.topViewController {
			self.topViewController = topViewController
		}

		navigationController.delegate = self
	}

	// MARK: - Internal methods

	func start() {
		showFileManagerScene(file: nil)
	}

	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated: Bool
	) {
		if viewController === topViewController {
			finishFlow?(nil)
		}
	}

	// MARK: - Private methods

	private func showFileManagerScene(file: File?) {
		let assembler = FileManagerAssembler(
			fileExplorer: fileExplorer,
			delegate: self,
			file: file
		)

		let viewController = assembler.assembly()
		navigationController.pushViewController(viewController, animated: true)
	}

	private func showTextPreviewScene(file: File) {
		let assembler = TextPreviewAssembler(file: file)
		let viewController = assembler.assembly()
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - IFileManagerDelegate

extension FileManagerCoordinator: IFileManagerDelegate {
	func openFolder(file: File) {
	}

	func openFile(file: File) {
	}
}
