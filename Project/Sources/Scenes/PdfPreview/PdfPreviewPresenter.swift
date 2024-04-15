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

	private let opQueue = OperationQueue()

	// swiftlint:disable:next implicitly_unwrapped_optional
	private var converter: MainQueueDispatchConverterDecorator<MarkdownToPdfConverter>!

	// MARK: - Private properties

	private let pdfAuthor: String

	// MARK: - Initialization

	init(viewController: PdfPreviewController, pdfAuthor: String) {
		self.viewController = viewController
		self.pdfAuthor = pdfAuthor
	}

	// MARK: - Public Methods

	func present(response: PdfPreviewModel.Response) {

		let downloadOperation = MdDocumentDownloadOperation(url: Endpoints.readmeUrl)

		let generatorOperation = PdfGeneratorOperation(pdfAuthor: pdfAuthor)
		let saverOperation = MdDocumentSaverOperation()

		generatorOperation.addDependency(downloadOperation)
		saverOperation.addDependency(downloadOperation)

		generatorOperation.completionBlock = { [weak self] in

			var title = ""

			if let documentName = downloadOperation.document?.name {
				title = documentName
			}

			let viewModel = PdfPreviewModel.ViewModel(
				currentTitle: title,
				data: generatorOperation.data
			)

			DispatchQueue.main.async {
				self?.viewController?.render(viewModel: viewModel)
			}
		}

		opQueue.addOperation(downloadOperation)
		opQueue.addOperation(generatorOperation)
		opQueue.addOperation(saverOperation)
	}
}
