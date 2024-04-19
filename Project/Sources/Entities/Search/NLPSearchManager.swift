//
//  NLPSearchManager.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/19/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import NaturalLanguage

protocol INLPSearchManager {
	func search(word: String, inText: String) -> [Range<String.Index>]
}

final class NLPSearchManager: INLPSearchManager {

	func search(word: String, inText text: String) -> [Range<String.Index>] {
		let searchTerm = lemmatizeWord(word)
		let taggedText = lemmatizeText(text)

		let matches = taggedText.filter { $0.tag == searchTerm }.map { $0.range }

		return matches
	}

	private struct TagToken {
		let token: String
		let tag: String
		let range: Range<String.Index>
	}

	private func lemmatizeText(_ text: String) -> [TagToken] {
		let tagger = NLTagger(tagSchemes: [.lemma])
		tagger.string = text

		var result: [TagToken] = []

		tagger.enumerateTags(
			in: text.startIndex ..< text.endIndex,
			unit: .word,
			scheme: .lemma,
			options: [.omitWhitespace, .omitPunctuation, .joinNames]
		) { tag, range in
			let token = String(text[range])

			if let tag = tag?.rawValue {
				result.append(TagToken(token: token, tag: tag, range: range))
			} else {
				result.append(TagToken(token: token, tag: token, range: range))
			}
			return true
		}

		return result
	}

	// TODO: Doesn't work. Need to be fixed.
	private func lemmatizeWord(_ word: String) -> String {
		let tagger = NLTagger(tagSchemes: [.lemma])
		tagger.string = word

		var result: String = word

		tagger.enumerateTags(
			in: word.startIndex ..< word.endIndex,
			unit: .word,
			scheme: .lemma,
			options: [.omitWhitespace, .omitPunctuation, .joinNames]
		) { tag, _ in
			if let tag = tag?.rawValue {
				result = tag
			}
			return true
		}

		return result
	}
}
