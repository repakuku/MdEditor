//
//  TextEditorAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import MarkdownPackage

final class TextEditorAssembler {

	// MARK: - Public methods

	func assembly(file: File, delegate: ITextEditorDelegate) -> TextEditorViewController {
		let viewController = TextEditorViewController()
		let presenter: ITextEditorPresenter = TextEditorPresenter(viewController: viewController)
		let interactor = TextEditorInteractor(
			presenter: presenter,
			file: file,
			delegate: delegate
		)
		viewController.interactor = interactor

		return viewController
	}
}
