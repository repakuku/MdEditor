//
//  AboutInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IAboutInteractor {
	func fetchData()
	func backButtonPressed()
}

final class AboutInteractor: IAboutInteractor {

	// MARK: - Dependencies

	private let presenter: IAboutPresenter
	private let fileExplorer: IFileExplorer

	// MARK: - Initialization

	init(presenter: IAboutPresenter, fileExplorer: IFileExplorer) {
		self.presenter = presenter
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public Methods

	func fetchData() {
		var response = AboutModel.Response(text: "")

		let files = fileExplorer.contentOfFolder(at: Bundle.main.bundleURL)
		switch files {
		case .success(let files):
			for file in files {
				if file.name == (L10n.aboutFileName + "." + file.ext) {
					response.text = String(data: (file.contentOfFile() ?? Data()), encoding: .utf8) ?? ""
				}
			}
		case .failure:
			break
		}

		presenter.present(response: response)
	}

	func backButtonPressed() {
		presenter.presentMainScreen()
	}
}
