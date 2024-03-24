//
//  PdfPreviewInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IPdfPreviewInteractor {
	func fetchData()
}

final class PdfPreviewInteractor: IPdfPreviewInteractor {

	// MARK: - Dependencies

	private let presenter: IPdfPreviewPresenter

	// MARK: - Private properties

	private let file: File

	// MARK: - Initialization

	init(presenter: IPdfPreviewPresenter, file: File) {
		self.presenter = presenter
		self.file = file
	}

	// MARK: - Public Methods

	func fetchData() {
		let content = String(data: file.contentOfFile() ?? Data(), encoding: .utf8) ?? ""
		let response = PdfPreviewModel.Response(fileUrl: file.url, fileContent: content)
		presenter.present(response: response)
	}
}
