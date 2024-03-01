//
//  Lexer.swift
//
//
//  Created by Alexey Turulin on 2/14/24.
//

import Foundation

/// Lexer protocol.
public protocol ILexer {

	/// Tokenizes a given string into an array of 'Token'.
	/// - Parameter input: The string to tokenize.
	/// - Returns: An array of 'Token'.
	func tokenize(_ input: String) -> [Token]
}

/// A Lexer class responsible for tokenizing Markdown text.
public final class Lexer: ILexer {

	// MARK: - Dependencies

	private let textParser: ITextParser

	// MARK: - Initializers

	/// Initializes a new Lexer instance.
	public init() {
		self.textParser = TextParser()
	}

	// MARK: - Public methods

	/// Tokenizes a given string into an array of 'Token'.
	/// - Parameter input: The string to tokenize.
	/// - Returns: An array of 'Token'.
	public func tokenize(_ input: String) -> [Token] {

		let lines = input.components(separatedBy: .newlines)
		var tokens = [Token?]()
		var inCodeBlock = false

		for line in lines {

			if let codeBlockToken = parseCodeBlockMarker(rawText: line) {
				tokens.append(codeBlockToken)
				inCodeBlock.toggle()
				continue
			}

			if !inCodeBlock {
				tokens.append(parseLineBreak(rawText: line))
				tokens.append(parseHeader(rawText: line))
				tokens.append(parseBlockquote(rawText: line))
				tokens.append(parseParagraph(rawText: line))
				tokens.append(parseTask(rawText: line))
			} else {
				tokens.append(.codeLine(text: line))
			}
		}

		return tokens.compactMap { $0 }
	}
}

private extension Lexer {

	// MARK: - Private methods

	func parseLineBreak(rawText: String) -> Token? {
		if rawText.isEmpty {
			return .lineBreak
		}

		return nil
	}

	func parseHeader(rawText: String) -> Token? {
		let pattern = #"^(#{1,6}) (.*)"#

		let groups = rawText.groups(for: pattern)
		if !groups.isEmpty, groups[0].count == 2 {
			let level = groups[0][0].count
			let text = groups[0][1]
			return .header(level: level, text: parseText(text))
		}
		return nil
	}

	func parseBlockquote(rawText: String) -> Token? {
		let pattern = #"^(>{1,6})(.*)"#
		let groups = rawText.groups(for: pattern)
		if !groups.isEmpty, groups[0].count == 2 {
			let level = groups[0][0].count
			let text = groups[0][1]
			return .blockquote(level: level, text: parseText(text))
		}
		return nil
	}

	func parseParagraph(rawText: String) -> Token? {
		if rawText.isEmpty { return nil }

		let notParagraphPattern = #"^(#|>|\s*- \[ \]|\s*- \[\*\]|\s*- \[x\]|\s*- \[X\]).*"#
		let regex = try? NSRegularExpression(pattern: notParagraphPattern)

		if  let notParagraph = regex?.match(rawText), notParagraph == true { return nil }

		return .textLine(text: parseText(rawText))
	}

	func parseCodeBlockMarker(rawText: String) -> Token? {
		let pattern = #"^`{2,6}(.*)"#

		if let text = rawText.group(for: pattern) {
			let level = rawText.filter { $0 == "`" }.count
			return .codeBlockMarker(level: level, lang: text)
		}

		return nil
	}

	func parseText(_ rawText: String) -> Text {
		textParser.parse(rawtext: rawText)
	}

	func parseTask(rawText: String) -> Token? {
		let pattern = #"\s*- \[[ *xX]\]\s+(.*)"#

		if let text = rawText.group(for: pattern) {
			let isDone = !rawText.contains("- [ ]")
			return .task(isDone: isDone, text: parseText(text))
		}

		return nil
	}
}
