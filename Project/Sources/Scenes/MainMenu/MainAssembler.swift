//
//  MainMenuAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class MainMenuAssembler {

	// MARK: - Dependencies

	private let fileExplorer: IFileExplorer

	// MARK: - Initializers

	init(fileExplorer: IFileExplorer) {
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public methods

	func assembly(closure: ((Screen) -> Void)?) -> MainMenuViewController {
		let viewController = MainMenuViewController()
		let presenter = MainMenuPresenter(
			viewController: viewController,
			closure: closure
		)
		let interactor = MainMenuInteractor(presenter: presenter, fileExplorer: fileExplorer)
		viewController.interactor = interactor

		return viewController
	}
}
