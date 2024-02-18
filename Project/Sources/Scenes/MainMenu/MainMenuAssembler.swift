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

	private let delegate: IMainMenuDelegate

	// MARK: - Initializers

	init(delegate: IMainMenuDelegate) {
		self.delegate = delegate
	}

	// MARK: - Public methods

	func assembly() -> MainMenuViewController {
		let viewController = MainMenuViewController()
		let presenter = MainMenuPresenter(
			viewController: viewController
		)
		let interactor = MainMenuInteractor(presenter: presenter, delegate: delegate)
		viewController.interactor = interactor

		return viewController
	}
}
