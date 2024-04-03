//
//  Token.swift
//
//
//  Created by Alexey Turulin on 2/14/24.
//

import Foundation

/// Represents elements identified in Markdown text.
public enum Token {

	/// A header with a specified 'level' and associated 'text'.
	case header(level: Int, text: Text)

	/// A blockquote with a specified 'level' and associated 'text'.
	case blockquote(level: Int, text: Text)

	/// Marks the beginning or end of a code block with a specified 'level' and programming 'language'.
	case codeBlockMarker(level: Int, lang: String)

	/// A line of code within a code block.
	case codeLine(text: String)

	/// A standard line of text.
	case textLine(text: Text)

	/// An unordered list item with specified 'level' and associated 'text'.
	case unorderedListItem(level: Int, text: Text)

	/// An ordered list item with specified 'level' and associated 'text'.
	case orderedListItem(level: Int, text: Text)

	/// An image with a source 'url' and 'size'.
	case image(url: String, size: Int)

	/// Represents a line break in the text.
	case lineBreak

	/// A task with a status and associated text.
	case task(isDone: Bool, text: Text)

	/// Represents a line  in the text.
	case line
}

/// Represents formatted text.
public struct Text: Equatable {

	/// An array of text parts, allowing for mixed formatting.
	let text: [Part]

	/// Represents a part of text with specific formatting.
	enum Part: Equatable {

		/// Plain text without any formatting.
		case normal(text: String)

		// Bold text.
		case bold(text: String)

		/// Italic text.
		case italic(text: String)

		/// Bold and italic text.
		case boldItalic(text: String)

		/// Text formatted as inline code.
		case inlineCode(text: String)

		/// An escaped character.
		case escapedChar(char: String)

		case highlighted(text: String)

		case strike(text: String)

		case externalLink(url: String, text: String)

		case internalLink(url: String)
	}
}

extension Token: Equatable {
	public static func == (lhs: Token, rhs: Token) -> Bool {
		switch (lhs, rhs) {
		case (.lineBreak, .lineBreak):
			return true
		case (.header(let lhsLevel, let lhsText), .header(let rhsLevel, let rhsText)):
			return lhsLevel == rhsLevel && lhsText == rhsText
		case (.blockquote(let lhsLevel, let lhsText), .blockquote(let rhsLevel, let rhsText)):
			return lhsLevel == rhsLevel && lhsText == rhsText
		default:
			return false
		}
	}
}
