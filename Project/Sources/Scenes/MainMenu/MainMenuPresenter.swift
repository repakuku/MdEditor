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
	private let closure: ((Screen) -> Void)?

	// MARK: - Initialization

	init(viewController: IMainMenuViewController, closure: ((Screen) -> Void)?) {
		self.viewController = viewController
		self.closure = closure
	}

	// MARK: - Public Methods

	func present(response: MainMenuModel.Response) {
	}

	func presentAboutScreen() {
	}

	func presentFileManagerScreen(response: MainMenuModel.Response) {
	}
}
