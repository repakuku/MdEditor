//
//  TextParser.swift
//
//
//  Created by Alexey Turulin on 2/14/24.
//

import Foundation

final class TextParser {
	private struct PartRegex {
		let type: PartType
		let regex: NSRegularExpression

		enum PartType: String {
			case plainText
			case boldText
			case italicText
			case boldItalicText
			case strikeText
			case highlightedText
			case inlineCode
			case escapedChar
			case externalLink
			case internalLink
		}

		init(type: TextParser.PartRegex.PartType, pattern: String) {
			self.type = type
			self.regex = try! NSRegularExpression(pattern: pattern) // swiftlint:disable:this force_try
		}
	}

	private let partRegexes = [
		PartRegex(type: .escapedChar, pattern: #"^\\(.)"#),
		PartRegex(type: .plainText, pattern: #"^([^\[\!]*?)(?=[\~\=\*\!\[`\\]|$)"#),
		PartRegex(type: .boldItalicText, pattern: #"^\*\*\*(.*?)\*\*\*"#),
		PartRegex(type: .boldText, pattern: #"^\*\*(.*?)\*\*"#),
		PartRegex(type: .italicText, pattern: #"^\*(.*?)\*"#),
		PartRegex(type: .strikeText, pattern: #"^\~\~(.*?)\~\~"#),
		PartRegex(type: .highlightedText, pattern: #"^\=\=(.*?)\=\="#),
		PartRegex(type: .inlineCode, pattern: #"^`(.*?)`"#),
		PartRegex(type: .externalLink, pattern: #"\[(.+)\]\((.+)\)"#),
		PartRegex(type: .internalLink, pattern: #"\[\[(.+)\]\]"#)
	]

	/// Parses raw markdown text into a structured 'Text' object.
	/// - Parameter text: A string containing raw markdown text.
	/// - Returns: A 'Text' object that represents the structured content of the input text.
	func parse(rawText text: String) -> Text { // swiftlint:disable:this function_body_length
		var parts = [Text.Part]()
		var range = NSRange(text.startIndex..., in: text)

		while range.location != NSNotFound && range.length != 0 {
			let startPartsCount = parts.count
			for partRegex in partRegexes {
				if let match = partRegex.regex.firstMatch(in: text, range: range),
				   let group0 = Range(match.range(at: 0), in: text),
				   let group1 = Range(match.range(at: 1), in: text) {

					let extractedText = String(text[group1])
					if !extractedText.isEmpty {
						switch partRegex.type {
						case .plainText:
							parts.append(.normal(text: extractedText))
						case .boldText:
							parts.append(.bold(text: extractedText))
						case .italicText:
							parts.append(.italic(text: extractedText))
						case .boldItalicText:
							parts.append(.boldItalic(text: extractedText))
						case .strikeText:
							parts.append(.strike(text: extractedText))
						case .highlightedText:
							parts.append(.highlighted(text: extractedText))
						case .inlineCode:
							parts.append(.inlineCode(text: extractedText))
						case .escapedChar:
							parts.append(.escapedChar(char: extractedText))
						case .externalLink:
							if let group2 = Range(match.range(at: 2), in: text) {
								let extractedUrl = String(text[group2])
								parts.append(.externalLink(url: extractedUrl, text: extractedText))
							} else {
								break
							}
						case .internalLink:
							parts.append(.internalLink(url: extractedText))
						}

						range = NSRange(group0.upperBound..., in: text)
						break
					}
				}
			}

			if parts.count == startPartsCount {
				let extractedText = String(text[Range(range, in: text)!]) // swiftlint:disable:this force_unwrapping
				parts.append(.normal(text: extractedText))
				break
			}
		}

		return Text(text: parts)
	}
}
