//
//  FreqWordService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/19/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

typealias FreqWords = [URL: Int]

protocol IFreqWordService {
	func freqWords(inFile: URL, fileEtension: String) -> [String: Int]
	func freqWordsInFiles(atPath searchPath: URL, fileExtension: String) -> [String: FreqWords]
	func searchWord(_ word: String, wordCount: [String: FreqWords]) -> FreqWords
}

final class FreqWordService: IFreqWordService {
	func freqWords(inFile fileUrl: URL, fileEtension: String = "md") -> [String: Int] {
		var results: [String: Int] = [:]
		guard fileUrl.pathExtension == fileEtension else { return results }

		do {
			let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
			let words = fileContent.components(separatedBy: .whitespacesAndNewlines)

			for word in words {
				guard !words.isEmpty else { continue }

				if word.count > 2 {
					results[word, default: 0] += 1
				}
			}
		} catch { }

		return results
	}

	func freqWordsInFiles(atPath searchPath: URL, fileExtension: String = "md") -> [String: FreqWords] {
		var results: [String: FreqWords] = [:]

		let fileManager = FileManager.default
		let enumerator = fileManager.enumerator(at: searchPath, includingPropertiesForKeys: nil)

		while let fileUrl = enumerator?.nextObject() as? URL {
			if fileExtension == fileUrl.pathExtension {
				let freqWordsResult = freqWords(inFile: fileUrl, fileEtension: fileExtension)

				freqWordsResult.keys.forEach { word in
					let count = freqWordsResult[word] ?? 0
					var freqWords = results[word] ?? [:]
					freqWords[fileUrl] = count
					results[word] = freqWords
				}
			}
		}

		return results
	}

	func searchWord(_ word: String, wordCount: [String: FreqWords]) -> FreqWords {
		if let freq = wordCount[word] {
			return freq
		} else {
			return [:]
		}
	}
}
