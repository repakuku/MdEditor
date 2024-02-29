//
//  MarkdownToDocumnet.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation

public protocol IMarkdownToDocument {
	func convert(markdownText: String) -> Document
}

public final class MarkdownToDocument: IMarkdownToDocument {

	// MARK: - Dependencies

	private let lexer = Lexer()
	private let parser = Parser()

	// MARK: - Initialization

	public init() { }

	// MARK: - Public Methods

	public func convert(markdownText: String) -> Document {
		let tokens = lexer.tokenize(markdownText)
		let document = parser.parse(tokens: tokens)
		return document
	}
}
