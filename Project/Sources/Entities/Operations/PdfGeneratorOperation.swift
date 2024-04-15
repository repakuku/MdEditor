//
//  PdfGeneratorOperation.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/4/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownPackage

final class PdfGeneratorOperation: Operation {
	private let pdfAuthor: String
	let document: MdDocument?

	var data = Data()

	init(pdfAuthor: String, document: MdDocument? = nil) {
		self.pdfAuthor = pdfAuthor
		self.document = document
		super.init()
	}

	override func main() {

		let dependencyDocument = dependencies.compactMap { ($0 as? IMdDocumentDataProvider)?.document }.first
		guard let document = document ?? dependencyDocument else { return }

		guard !isCancelled else { return }

		let converter = MarkdownToPdfConverter(
			pageSize: .screen,
			backgroundColor: Theme.backgroundColor,
			pdfAuthor: pdfAuthor,
			pdfTitle: document.name
		)

		converter.convert(markdownText: document.body) { [weak self] data in
			self?.data = data
		}
	}
}

extension PdfGeneratorOperation: IMdDocumentDataProvider { }
