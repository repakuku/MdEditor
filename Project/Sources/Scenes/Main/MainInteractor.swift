//
//  MainInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainInteractor {
	func fetchData()
	func buttonAboutPressed()
}

final class MainInteractor: IMainInteractor {

	// MARK: - Dependencies

	private var presenter: IMainPresenter?
	private var fileExplorer: IFileExplorer?

	// MARK: - Initialization

	init(presenter: IMainPresenter, fileExplorer: IFileExplorer) {
		self.presenter = presenter
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public Methods

	func fetchData() {
		var response = MainModel.Response(files: [])

		if let files = fileExplorer?.getFiles(from: "/Notes") {
			response.files = files
		}

		presenter?.present(response: response)
	}

	func buttonAboutPressed() {
		presenter?.presentAboutScreen()
	}
}
