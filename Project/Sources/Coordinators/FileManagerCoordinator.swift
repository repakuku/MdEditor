//
//  FileManagerCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class FileManagerCoordinator: ICoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let fileExplorer: IFileExplorer
	private let delegate: IFileManagerDelegate

	// MARK: - Internal properties

	var finishFlow: (() -> Void)?

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

	func start() {
		showFileManagerScene()
	}

	func showFileManagerScene() {
		let assembler = FileManagerAssembler(
			fileExplorer: fileExplorer,
			delegate: delegate,
			file: nil
		)

		let viewController = assembler.assemble { [weak self] _ in
		}
		navigationController.pushViewController(viewController, animated: true)
	}
}
