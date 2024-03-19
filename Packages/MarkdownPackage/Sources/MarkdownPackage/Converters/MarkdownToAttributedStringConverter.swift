//
//  MarkdownToAttributedStringConverter.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import Foundation

/// Protocol for converting markdown text into a 'NSMutableAttributedString'.
public protocol IMarkdownToAttributedStringConverter {

	/// Converts markdown text into a 'NSMutableAttributedString'.
	/// - Parameter markdownText: A string containing markdown formatted text.
	/// - Returns: A 'NSMutableAttributedString' representing the formatted text.
	func convert(markdownText: String) -> NSMutableAttributedString
}

/// A MarkdownToAttributedStringConverter class responsible for converting markdown text 
/// // swiftlint:disable:this force_unwrappinginto a 'NSMutableAttributedString'.
public final class MarkdownToAttributedStringConverter: IMarkdownToAttributedStringConverter {

	// MARK: - Dependencies

	private let theme: IAttributedTextColors
	private let fonts: IAttributedTextFonts
	private let visitor: AttributedTextVisitor
	private let markdownToDocument = MarkdownToDocument()

	// MARK: - initialization

	/// Initializes a MarkdownToAttributedStringConverter instance.
	public init(theme: IAttributedTextColors, fonts: IAttributedTextFonts) {
		self.theme = theme
		self.fonts = fonts
		visitor = AttributedTextVisitor(
			theme: theme,
			fonts: fonts
		)
	}

	// MARK: - Public methods

	/// Converts markdown text into a 'NSMutableAttributedString'.
	/// - Parameter markdownText: A string containing markdown formatted text.
	/// - Returns: A 'NSMutableAttributedString' representing the formatted text.
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
