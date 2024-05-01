//
//  MainMenuAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class MainMenuAssembler {

	// MARK: - Public methods

	func assembly(recentFileManager: IRecentFileManager, delegate: IMainMenuDelegate) -> MainMenuViewController {
		let viewController = MainMenuViewController()
		let presenter = MainMenuPresenter(viewController: viewController)
		let interactor = MainMenuInteractor(
			presenter: presenter,
			recentFileManager: recentFileManager,
			delegate: delegate
		)
		viewController.interactor = interactor

		return viewController
	}
}
