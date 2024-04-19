//
//  ExtractTagService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/18/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IExtractTagService {
	func extractTag(fromFile fileUrl: URL) -> [String]
	func extractTagFromFiles(atPath searchPath: URL, fileExtension: String) -> [String]
}

final class ExtractTagService: IExtractTagService {
	func extractTag(fromFile fileUrl: URL) -> [String] {
		do {
			let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
			let tags = fileContent
				.components(separatedBy: .whitespacesAndNewlines)
				.filter { $0.range(of: #"^#[A-z0-9_]+$"#, options: .regularExpression) != nil }
			return tags
		} catch { }

		return []
	}

	func extractTagFromFiles(atPath searchPath: URL, fileExtension: String = "md") -> [String] {
		var result = [String]()

		let fileManager = FileManager.default
		let enumerator = fileManager.enumerator(at: searchPath, includingPropertiesForKeys: nil)

		while let fileUrl = enumerator?.nextObject() as? URL {
			if fileExtension == fileUrl.pathExtension {
				let tags = extractTag(fromFile: fileUrl)
				result.append(contentsOf: tags)
			}
		}

		return Array(Set(result))
	}
}
