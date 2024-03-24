//
//  PdfPreviewPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownPackage

protocol IPdfPreviewPresenter {
	func present(response: PdfPreviewModel.Response)
}

final class PdfPreviewPresenter: IPdfPreviewPresenter {

	// MARK: - Dependencies

	private weak var viewController: IPdfPreviewController?

	// MARK: - Private properties

	private let pdfAuthor: String

	// MARK: - Initialization

	init(viewController: PdfPreviewController, pdfAuthor: String) {
		self.viewController = viewController
		self.pdfAuthor = pdfAuthor
	}

	// MARK: - Public Methods

	func present(response: PdfPreviewModel.Response) {
		let pdfTitle = response.fileUrl.lastPathComponent

		let converter = MainQueueDispatchDecorator(
			decoratee: MarkdownToPdfConverter(
				pageSize: .screen,
				backgroundColor: Theme.backgroundColor,
				pdfAuthor: pdfAuthor,
				pdfTitle: pdfTitle
			)
		)

		converter.convert(
			markdownText: response.fileContent
		) { [weak self] data in
			let viewModel = PdfPreviewModel.ViewModel(
				currentTitle: response.fileUrl.lastPathComponent,
				data: data
			)

			self?.viewController?.render(viewModel: viewModel)
		}
	}
}
