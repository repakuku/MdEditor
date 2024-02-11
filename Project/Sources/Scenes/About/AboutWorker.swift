//
//  AboutWorker.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IAboutWorker {
	func convert(_ text: String) -> String
}

final class AboutWorker: IAboutWorker {

	// MARK: - Dependencies

	private var converter: IMarkdownToHTMLConverter?

	// MARK: - Initialization

	init(converter: IMarkdownToHTMLConverter) {
		self.converter = converter
	}

	// MARK: - Public Methods

	func convert(_ text: String) -> String {
		converter?.convert(text) ?? text
	}
}
