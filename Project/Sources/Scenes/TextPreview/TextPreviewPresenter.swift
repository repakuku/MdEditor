//
//  TextPreviewPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownParserPackage

protocol ITextPreviewPresenter {
	func present(response: TextPreviewModel.Response)
}

final class TextPreviewPresenter: ITextPreviewPresenter {

	// MARK: - Dependencies

	private weak var viewController: ITextPreviewViewController?

	// MARK: - Initialization

	init(viewController: TextPreviewViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

	#warning("TODO: Fix dependencies here")
	func present(response: TextPreviewModel.Response) {

		let tokens = Lexer().tokenize(response.fileContent)
		let document = Parser().parse(tokens: tokens)
		let visitor = AttributedTextVisitor()
		let attributedText = document.accept(visitor: visitor).joined()

		let viewModel = TextPreviewModel.ViewModel(
			currentTitle: response.fileUrl.lastPathComponent,
			text: attributedText
		)
		viewController?.render(viewModel: viewModel)
	}
}
