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
	private let fileExplorer: IFileExplorer

	// MARK: - Initialization

	init(viewController: IMainViewController, fileExplorer: IFileExplorer) {
		self.viewController = viewController
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public Methods

	func present() {
		let recentFiles = fileExplorer.getRecentFiles()
		let viewModel = MainModel.ViewModel(recentFiles: recentFiles)
		viewController?.render(viewModel: viewModel)
	}
}
