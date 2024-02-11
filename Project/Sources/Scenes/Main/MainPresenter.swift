//
//  MainPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainPresenter {
	func present()
}

final class MainPresenter: IMainPresenter {

	// MARK: - Dependencies

	private weak var viewController: IMainViewController?
	private let fileExplorer: FileExplorer

	// MARK: - Initialization

	init(viewController: IMainViewController, fileExplorer: FileExplorer) {
		self.viewController = viewController
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public Methods

	func present() {
		let recentFiles = fileExplorer.getRecentFiles()
		var onlyFiles = [MainModel.ViewModel.RecentFile]()

		for file in recentFiles {
			let file = MainModel.ViewModel.RecentFile(name: file.name)
			onlyFiles.append(file)
		}

		let viewModel = MainModel.ViewModel(recentFiles: onlyFiles)
		viewController?.render(viewModel: viewModel)
	}
}
