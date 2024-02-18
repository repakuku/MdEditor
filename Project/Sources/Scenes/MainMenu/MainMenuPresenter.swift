//
//  MainMenuPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainMenuPresenter {
	func present(response: MainMenuModel.Response)
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
		let viewModel = MainMenuModel.ViewModel(recentFiles: [], menu: [])
		viewController?.render(viewModel: viewModel)
	}
}
