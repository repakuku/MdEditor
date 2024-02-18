//
//  MainMenuPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum Screen {
	case main
	case fileManager(files: [File])
	case about
}

protocol IMainMenuPresenter {
	func present(response: MainMenuModel.Response)
	func presentAboutScreen()
	func presentFileManagerScreen(response: MainMenuModel.Response)
}

final class MainMenuPresenter: IMainMenuPresenter {

	// MARK: - Dependencies

	private weak var viewController: IMainMenuViewController?

	// MARK: - Initialization

	init(viewController: IMainMenuViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

	func present(response: MainMenuModel.Response) {
	}

	func presentAboutScreen() {
	}

	func presentFileManagerScreen(response: MainMenuModel.Response) {
	}
}
