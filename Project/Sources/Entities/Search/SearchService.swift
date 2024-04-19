//
//  SearchService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/18/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct SearchResult {
	let fileUrl: URL
	let lineText: String
	let lineNumber: Int
}

protocol ISearchService {
	func searchText(inFile fileUrl: URL, text: String) -> [SearchResult]
	func searchTextInFiles(atPath searchPath: URL, fileExtension: String, text: String) -> [SearchResult]
}

final class SearchService: ISearchService {
	func searchText(inFile fileUrl: URL, text: String) -> [SearchResult] {
		var result = [SearchResult]()

		do {
			let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
			let lines = fileContent.components(separatedBy: .newlines)

			for (index, line) in lines.enumerated() {
				if line.contains(text) {
					let searchResult = SearchResult(
						fileUrl: fileUrl,
						lineText: line,
						lineNumber: index + 1
					)
					result.append(searchResult)
				}
			}
		} catch { }

		return result
	}

	func searchTextInFiles(atPath searchPath: URL, fileExtension: String = "md", text: String) -> [SearchResult] {
		var result = [SearchResult]()

		let fileManager = FileManager.default
		let enumerator = fileManager.enumerator(at: searchPath, includingPropertiesForKeys: nil)

		while let fileUrl = enumerator?.nextObject() as? URL {
			if fileExtension == fileUrl.pathExtension {
				let searchResult = searchText(inFile: fileUrl, text: text)
				result.append(contentsOf: searchResult)
			}
		}

		return result
	}
}
