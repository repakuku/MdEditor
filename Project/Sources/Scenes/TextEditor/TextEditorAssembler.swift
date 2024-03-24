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

	// MARK: - Dependencies

	private let file: File

	private let converter = MarkdownToRawAttributedStringConverter()

	// MARK: - Initializers

	init(
		file: File
	) {
		self.file = file
	}

	// MARK: - Public methods

	func assembly() -> (TextEditorViewController, TextEditorInteractor) {
		let viewController = TextEditorViewController()
		let presenter: ITextEditorPresenter = TextEditorPresenter(viewController: viewController)
		let interactor = TextEditorInteractor(
			presenter: presenter,
			file: file
		)
		viewController.interactor = interactor

		return (viewController, interactor)
	}
}
