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

	// MARK: - Private properties

	private let pdfAuthor: String

	// MARK: - Initializers

	init(file: File) {
		self.file = file
		pdfAuthor = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
	}

	// MARK: - Public methods

	func assembly() -> (PdfPreviewController, PdfPreviewInteractor) {
		let viewController = PdfPreviewController()

		let presenter: IPdfPreviewPresenter = PdfPreviewPresenter(
			viewController: viewController,
			pdfAuthor: pdfAuthor
		)

		let interactor = PdfPreviewInteractor(
			presenter: presenter,
			file: file
		)

		viewController.interactor = interactor

		return (viewController, interactor)
	}
}
