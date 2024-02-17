//
//  MainMenuInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainMenuInteractor {
	func fetchData()
	func buttonAboutPressed()
	func buttonOpenPressed()
}

final class MainMenuInteractor: IMainMenuInteractor {

	// MARK: - Dependencies

	private let presenter: IMainMenuPresenter
	private let fileExplorer: IFileExplorer

	// MARK: - Initialization

	init(presenter: IMainMenuPresenter, fileExplorer: IFileExplorer) {
		self.presenter = presenter
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public Methods

	func fetchData() {
	}

	func buttonAboutPressed() {
	}

	func buttonOpenPressed() {
	}
}
