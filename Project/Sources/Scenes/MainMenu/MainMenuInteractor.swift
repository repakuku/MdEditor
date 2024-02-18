//
//  MainMenuInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainMenuDelegate {
	func showAbout()
	func openFile()
	func openFile(file: File)
	func newFile()
}

protocol IMainMenuInteractor {
	func fetchData()
}

final class MainMenuInteractor: IMainMenuInteractor {

	// MARK: - Dependencies

	private let presenter: IMainMenuPresenter

	// MARK: - Initialization

	init(presenter: IMainMenuPresenter) {
		self.presenter = presenter
	}

	// MARK: - Public Methods

	func fetchData() {
	}
}
