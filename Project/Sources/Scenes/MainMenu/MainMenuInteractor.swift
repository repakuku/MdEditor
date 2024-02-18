//
//  MainMenuInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainMenuDelegate: AnyObject {
	func showAbout()
	func openFile()
	func openFile(file: File)
	func newFile()
}

protocol IMainMenuInteractor {
	func fetchData()
	func performAction(request: MainMenuModel.MenuIdentifier)
}

final class MainMenuInteractor: IMainMenuInteractor {

	// MARK: - Dependencies

	private let presenter: IMainMenuPresenter
	private weak var delegate: IMainMenuDelegate?

	// MARK: - Initialization

	init(presenter: IMainMenuPresenter, delegate: IMainMenuDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	// MARK: - Public Methods

	func fetchData() {
		let response = MainMenuModel.Response(recentFiles: [], menu: [])
		presenter.present(response: response)
	}

	func performAction(request: MainMenuModel.MenuIdentifier) {
		switch request {
		case .openFIle:
			delegate?.openFile()
		case .newFile:
			delegate?.newFile()
		case .showAbout:
			delegate?.showAbout()
		}
	}
}
