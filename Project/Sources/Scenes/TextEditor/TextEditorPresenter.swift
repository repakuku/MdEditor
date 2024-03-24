//
//  TextEditorPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownPackage

protocol ITextEditorPresenter {
	func present(response: TextEditorModel.Response)
}

final class TextEditorPresenter: ITextEditorPresenter {

	// MARK: - Dependencies

	private weak var viewController: ITextEditorViewController?

	// MARK: - Initialization

	init(viewController: TextEditorViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

	func present(response: TextEditorModel.Response) {
		switch response {
		case .initial(let fileUrl, let fileContent):
			let document = MarkdownToDocument().convert(markdownText: fileContent)
			let taskRepository: ITaskRepository = TaskScanner(document: document)
			let viewModel = TextEditorModel.ViewModel.initial(
				text: fileContent,
				title: fileUrl.lastPathComponent,
				hasTasks: !taskRepository.getTasks().isEmpty
			)
			viewController?.render(viewModel: viewModel)
		case .convert(let text):
			let document = MarkdownToDocument().convert(markdownText: text)
			let taskRepository: ITaskRepository = TaskScanner(document: document)
			let attributedText = MarkdownToRawAttributedStringConverter().convert(markdownText: text)
			let viewModel = TextEditorModel.ViewModel.convert(
				text: attributedText,
				hasTasks: !taskRepository.getTasks().isEmpty
			)
			viewController?.render(viewModel: viewModel)
		case .print(let text):
			MarkdownToPdfConverter(
				pageSize: .a4,
				backgroundColor: .white,
				pdfAuthor: "repakuku",
				pdfTitle: ""
			).convert(markdownText: text) { [weak self] data in
				let viewModel = TextEditorModel.ViewModel.print(data: data)
				self?.viewController?.render(viewModel: viewModel)
			}
		}
	}
}
