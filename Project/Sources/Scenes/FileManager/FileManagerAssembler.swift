//
//  FileManagerAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class FileManagerAssembler {

	// MARK: - Dependencies

	private let fileExplorer: IFileExplorer
	private let delegate: IFileManagerDelegate
	private let file: File?

	// MARK: - Initializers

	init(fileExplorer: IFileExplorer, delegate: IFileManagerDelegate, file: File?) {
		self.fileExplorer = fileExplorer
		self.delegate = delegate
		self.file = file
	}

	// MARK: - Public methods

	func assemble(backClosure: ((Screen) -> Void)?) -> FileManagerViewController {
		let viewController = FileManagerViewController()
		let presenter = FileManagerPresenter(
			viewController: viewController,
			backClosure: backClosure
		)
		let interactor: IFileManagerInteractor = FileManagerInteractor(
			presenter: presenter,
			fileExplorer: fileExplorer,
			delegate: delegate,
			file: file
		)
		viewController.interactor = interactor

		return viewController
	}
}
