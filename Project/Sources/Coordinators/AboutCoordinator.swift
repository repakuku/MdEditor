//
//  AboutCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class AboutCoordinator: ICoordinator {

	// MARK: - Dependencies

	private let navigationController: UINavigationController
	private let fileExplorer: IFileExplorer

	// MARK: - Internal properties

	var finishFlow: (() -> Void)?

	// MARK: - Initialization

	init(navigationController: UINavigationController, fileExplorer: IFileExplorer) {
		self.navigationController = navigationController
		self.fileExplorer = fileExplorer
	}

	// MARK: - Internal methods

	func start() {
		showAboutScene()
	}

	func showAboutScene() {
		let assembler = AboutAssembler(fileExplorer: fileExplorer)
		let viewController = assembler.assembly { [weak self] in
			self?.finishFlow?()
		}
		navigationController.pushViewController(viewController, animated: true)
	}
}
