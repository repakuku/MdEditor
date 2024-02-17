//
//  MainMenuPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum NextScreen {
	case open
	case about
}

protocol IMainMenuPresenter {
	func present(response: MainMenuModel.Response)
	func presentAboutScreen()
	func presentOpenScreen()
}

final class MainMenuPresenter: IMainMenuPresenter {

	// MARK: - Dependencies

	private weak var viewController: IMainMenuViewController?
	private let closure: ((NextScreen) -> Void)?

	// MARK: - Initialization

	init(viewController: IMainMenuViewController, closure: ((NextScreen) -> Void)?) {
		self.viewController = viewController
		self.closure = closure
	}

	// MARK: - Public Methods

	func present(response: MainMenuModel.Response) {
		var onlyFiles = [MainMenuModel.ViewModel.File]()

		for file in response.files {
			let file = MainMenuModel.ViewModel.File(name: file.name)
			onlyFiles.append(file)
		}

		let viewModel = MainMenuModel.ViewModel(recentFiles: onlyFiles)
		viewController?.render(viewModel: viewModel)
	}

	func presentAboutScreen() {
		closure?(.about)
	}

	func presentOpenScreen() {
		closure?(.open)
	}
}
