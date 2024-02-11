//
//  MarkdownToHTMLConverter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMarkdownToHTMLConverter {
	func convert(_ text: String) -> String
}

final class MarkdownToHTMLConverter: IMarkdownToHTMLConverter {

	// MARK: - Public methods

	func convert(_ text: String) -> String {

		let lines = text.components(separatedBy: .newlines)
		var html = [String?]()

		lines.forEach { line in
			html.append(parseText(line))
//			html.append(parseHeader(text: line))
//			html.append(parseBlockquote(text: line))
//			html.append(parseParagraph(text: line))
		}

		return makeHTML(html.compactMap { $0 }.joined())
	}
}

extension MarkdownToHTMLConverter {
	func makeHTML(_ text: String) -> String {
		"<!DOCTYPE html><html><head><style> body {font-size: 350%;} </style></head><body>\(text)</body></html>"
	}

//	func parseHeader(text: String) -> String? {
//		let regex = /^(?<headerLevel>#{1,6})\s+(?<headerText>.+)/
//		
//		if let match = text.wholeMatch(of: regex) {
//			let headerLevel = String(match.headerLevel).count
//			let headerText = parseText(String(match.headerText))
//			return "<h\(headerLevel)>\(headerText)</h\(headerLevel)>"
//		}
//		
//		return nil
//	}

//	func parseBlockquote(text: String) -> String? {
//		let regex = /^>\s+(.+)/
//		
//		if let match = text.wholeMatch(of: regex) {
//			// match.output - результат совпадения
//			// 1 - номер группы
//			let blockquoteText = parseText(String(match.output.1))
//			return "<blockquote><p>\(blockquoteText)</p></blockquote>"
//		}
//		
//		return nil
//	}

	func parseText(_ text: String) -> String {
		let boldItalicPattern = #"\*\*\*(.+?)\*\*\*"#
		let boldPattern = #"\*\*(.+?)\*\*"#
		let italicPattern =  #"\*(.+?)\*"#

		var result = text

		result = text.replacingOccurrences(
			of: boldItalicPattern,
			with: "<strong><em>$1</em></strong>",
			options: .regularExpression
		)

		result = result.replacingOccurrences(
			of: boldPattern,
			with: "<strong>$1</strong>",
			options: .regularExpression
		)

		result = result.replacingOccurrences(
			of: italicPattern,
			with: "<em>$1</em>",
			options: .regularExpression
		)

		return result
	}

//	func parseParagraph(text: String) -> String? {
//		let regex = /^([^#>].*)/
//		
//		if let match = text.wholeMatch(of: regex) {
//			let paragraphText = parseText(String(match.output.1))
//			return "<p>\(paragraphText)</p>"
//		}
//		
//		return nil
//	}
}
