//
//  FileManagerPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFileManagerPresenter {
	func present(response: FileManagerModel.Response)
	func presentMainScreen()
	func presentSelectedFile(response: FileManagerModel.Response)
}

final class FileManagerPresenter: IFileManagerPresenter {

	// MARK: - Dependencies

	private weak var viewController: FileManagerViewController?
	private let backClosure: ((Screen) -> Void)?

	// MARK: - Initialization

	init(viewController: FileManagerViewController, backClosure: ((Screen) -> Void)?) {
		self.viewController = viewController
		self.backClosure = backClosure
	}

	// MARK: - Public Methods

	func present(response: FileManagerModel.Response) {
	}

	func presentMainScreen() {
	}

	func presentSelectedFile(response: FileManagerModel.Response) {
	}

	// MARK: - Private dependencies

	private func mapFile(_ file: File) -> FileManagerModel.ViewModel.FileModel {

		let info = ""

		return FileManagerModel.ViewModel.FileModel(name: file.name, info: info, isFolder: file.isFolder)
	}
}
