//
//  TextEditorInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ITextEditorDelegate: AnyObject {
	func openTodoList(text: String)
}

protocol ITextEditorInteractor {
	func fetchData()
	func needConvertText(text: String)
	func openTodoList(text: String)
	func print(text: String)
}

final class TextEditorInteractor: ITextEditorInteractor {

	// MARK: - Dependencies

	private let presenter: ITextEditorPresenter
	private var delegate: ITextEditorDelegate?

	// MARK: - Private properties

	private let file: File
	private let searchText: String?

	// MARK: - Initialization

	init(
		presenter: ITextEditorPresenter,
		file: File,
		searchText: String? = nil,
		delegate: ITextEditorDelegate
	) {
		self.presenter = presenter
		self.file = file
		self.searchText = searchText
		self.delegate = delegate
	}

	// MARK: - Public Methods

	func fetchData() {
		let content = String(data: file.contentOfFile() ?? Data(), encoding: .utf8) ?? ""
		let response = TextEditorModel.Response.initial(
			fileUrl: file.url,
			fileContent: content,
			searchText: searchText
		)
		presenter.present(response: response)
	}

	func needConvertText(text: String) {
		presenter.present(response: TextEditorModel.Response.convert(text: text))
	}

	func openTodoList(text: String) {
		delegate?.openTodoList(text: text)
	}

	func print(text: String) {
		presenter.present(response: TextEditorModel.Response.print(text: text))
	}
}
