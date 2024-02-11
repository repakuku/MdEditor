//
//  StartCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/6/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class MainCoordinator: ICoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let fileExplorer: IFileExplorer

	// MARK: - Internal properties

	var finishFlow: ((Int) -> Void)?

	// MARK: - Initialization

	init(navigationController: UINavigationController, fileExplorer: IFileExplorer) {
		self.navigationController = navigationController
		self.fileExplorer = fileExplorer
	}

	// MARK: - Internal methods

	func start() {
		showMainScene()
	}

	func showMainScene() {
		let assembler = MainAssembler(fileExplorer: fileExplorer)
		let viewController = assembler.assembly { [weak self] index in
			self?.finishFlow?(index)
		}
		navigationController.pushViewController(viewController, animated: true)
	}
}
