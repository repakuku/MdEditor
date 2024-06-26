//
//  MarkdownToDocumnet.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation

/// A MarkdownToDocument class responsible for converting markdown text into a 'Document' object.
public final class MarkdownToDocument: IMarkdownConverter {

	// MARK: - Dependencies

	private let lexer = Lexer()
	private let parser = Parser()

	// MARK: - Initialization

	/// Initializes a MarkdownToDocument instance.
	public init() { }

	// MARK: - Public Methods

	/// Converts markdown text to a 'Document' object.
	/// - Parameter markdownText: A string containing markdown formatted text.
	/// - Returns: A 'Document' object representing the structured version of the markdown text.
	public func convert(markdownText: String) -> Document {
		let tokens = lexer.tokenize(markdownText)
		let document = parser.parse(tokens: tokens)
		return document
	}
	
	public func convert(markdownText: String, completion: @escaping (Document) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let self else { return }
			let result = convert(markdownText: markdownText)
			completion(result)
		}
	}
}
