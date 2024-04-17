//
//  FileManagerAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class FileManagerAssembler {

	// MARK: - Public methods

	func assembly(
		fileExplorer: IFileExplorer,
		file: File?,
		delegate: IFileManagerDelegate
	) -> FileManagerViewController {
		let viewController = FileManagerViewController()
		let presenter = FileManagerPresenter(
			viewController: viewController
		)
		let interactor = FileManagerInteractor(
			presenter: presenter,
			fileExplorer: fileExplorer,
			delegate: delegate,
			file: file
		)
		viewController.interactor = interactor
		return viewController
	}
}
