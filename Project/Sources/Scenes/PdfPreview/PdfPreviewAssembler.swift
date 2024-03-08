//
//  PdfPreviewAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import MarkdownPackage

final class PdfPreviewAssembler {

	// MARK: - Dependencies

	private let file: File

	private let converter = MarkdownToPdfConverter()

	// MARK: - Initializers

	init(
		file: File
	) {
		self.file = file
	}

	// MARK: - Public methods

	func assembly() -> PdfPreviewController {
		let viewController = PdfPreviewController()
		let presenter: IPdfPreviewPresenter = PdfPreviewPresenter(
			viewController: viewController,
			converter: converter
		)
		let interactor: IPdfPreviewInteractor = PdfPreviewInteractor(
			presenter: presenter,
			file: file
		)
		viewController.interactor = interactor

		return viewController
	}
}
