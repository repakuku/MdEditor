//
//  AboutAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class AboutAssembler {

	// MARK: - Dependencies

	private let fileExplorer: IFileExplorer

	// MARK: - Initializers

	init(fileExplorer: IFileExplorer) {
		self.fileExplorer = fileExplorer
	}

	// MARK: - Public methods

	func assembly(backClosure: (() -> Void)?) -> AboutViewController {
		let viewController = AboutViewController()
		let presenter: IAboutPresenter = AboutPresenter(
			viewController: viewController,
			backClosure: backClosure
		)
		let interactor: IAboutInteractor = AboutInteractor(presenter: presenter, fileExplorer: fileExplorer)

		viewController.interactor = interactor

		return viewController
	}
}
