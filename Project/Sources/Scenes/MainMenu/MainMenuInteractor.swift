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
	func openFileExplorer()
	func openFile(file: File)
	func search()
	func newFile()
}

protocol IMainMenuInteractor {
	func fetchData()
	func performAction(request: MainMenuModel.Request)
}

final class MainMenuInteractor: IMainMenuInteractor {

	// MARK: - Dependencies

	private let presenter: IMainMenuPresenter
	private let recentFileManager: IRecentFileManager
	private var delegate: IMainMenuDelegate?

	// MARK: - Private properties

	private let menu: [MainMenuModel.MenuIdentifier] = [
		.newFile,
		.openFile,
		.separator,
		.search,
		.tags,
		.separator,
		.showAbout
	]

	// MARK: - Initialization

	init(
		presenter: IMainMenuPresenter,
		recentFileManager: IRecentFileManager,
		delegate: IMainMenuDelegate
	) {
		self.presenter = presenter
		self.recentFileManager = recentFileManager
		self.delegate = delegate
	}

	// MARK: - Public Methods

	func fetchData() {
		let recentFiles = recentFileManager.getRecentFiles()
		let response = MainMenuModel.Response(recentFiles: recentFiles, menu: menu)
		presenter.present(response: response)
	}

	func performAction(request: MainMenuModel.Request) {
		switch request {
		case .menuItemSelected(let indexPath):
			let selectedMenuItem = menu[min(indexPath.row, menu.count - 1)]
			switch selectedMenuItem {
			case .openFile:
				delegate?.openFileExplorer()
			case .newFile:
				delegate?.newFile()
			case .search:
				delegate?.search()
			case .tags:
				// TODO: Change method
				delegate?.search()
			case .showAbout:
				delegate?.showAbout()
			case .separator:
				break
			}
		case .recentFileSelected(let indexPath):
			let recentFiles = recentFileManager.getRecentFiles()
			let recentFile = recentFiles[min(indexPath.row, recentFiles.count - 1)]
			if case .success(let file) = File.parse(url: recentFile.url) {
				delegate?.openFile(file: file)
			}
		}
	}
}
