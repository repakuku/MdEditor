//
//  MarkdownToAttributedStringConverter.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import UIKit

public protocol IMarkdownToAttributedStringConverter {
	func convert(markdownText: String) -> NSMutableAttributedString
}

public final class MarkdownToAttributedStringConverter: IMarkdownToAttributedStringConverter {

	// MARK: - Dependencies

	private let visitor = AttributedTextVisitor()
	private let markdownToDocument = MarkdownToDocument()

	// MARK: - initialization

	public init() { }

	// MARK: - Public methods

	public func convert(markdownText: String) -> NSMutableAttributedString {
		let documnet = markdownToDocument.convert(markdownText: markdownText)
		return convert(document: documnet)
	}

	// MARK: - Private methods

	private func convert(document: Document) -> NSMutableAttributedString {
		let attributedText = document.accept(visitor: visitor).joined()
		return attributedText
	}
}
