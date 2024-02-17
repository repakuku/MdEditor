//
//  File.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct File {
	let url: URL
	let isFolder: Bool
	let size: UInt64
	let creationDate: Date
	let modificationDate: Date

	private init(url: URL, isFolder: Bool, size: UInt64, creationDate: Date, modificationDate: Date) {
		self.url = url
		self.isFolder = isFolder
		self.size = size
		self.creationDate = creationDate
		self.modificationDate = modificationDate
	}

	enum ParseError: Error {
		case wrongAttribute
	}

	static func parse(url: URL) -> Result<File, Error> {
		let fileManager = FileManager.default
		do {
			let attributes = try fileManager.attributesOfItem(atPath: url.relativePath)
			if
				let type = attributes[.type] as? FileAttributeType,
				let size = attributes[.size] as? UInt64,
				let creationDate = attributes[.creationDate] as? Date,
				let modoficationDate = attributes[.modificationDate] as? Date
			{
				let file = File(
					url: url,
					isFolder: type == .typeDirectory,
					size: size,
					creationDate: creationDate,
					modificationDate: modoficationDate
				)
				return .success(file)
			} else {
				return .failure(ParseError.wrongAttribute)
			}
		} catch {
			return .failure(error)
		}
	}

	var fullName: String {
		url.absoluteString
	}

	var path: String {
		url.deletingLastPathComponent().absoluteString
	}

	var name: String {
		url.lastPathComponent
	}

	var ext: String {
		url.pathExtension
	}

	func contentOfFile() -> Data? {
		try? Data(contentsOf: url)
	}

//	func getFormattedSize() -> String {
//		return getFormattedSize(with: size)
//	}
//
//	func getFormattedAttributes() -> String {
//		let formattedSize = getFormattedSize()
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
//
//		switch type {
//		case .file:
//			return "\"\(ext)\" – \(dateFormatter.string(from: modificationDate)) | \(formattedSize)"
//		case .folder:
//			return "\(dateFormatter.string(from: modificationDate)) | <dir>"
//		}
//	}
//
//	func getImage() -> String {
//		switch type {
//		case .file:
//			return "doc"
//		case .folder:
//			return "folder"
//		}
//	}
//
//	func loadFileBody() -> String {
//		var text = ""
//		let fullPath = Bundle.main.resourcePath! + "\(path)/\(name)" // swiftlint:disable:this force_unwrapping
//
//		do {
//			text = try String(contentsOfFile: fullPath, encoding: .utf8)
//		} catch {
//			print("Failed to read text from \(name)") // swiftlint:disable:this print_using
//		}
//
//		return text
//	}
//
//	private func getFormattedSize(with size: UInt64) -> String {
//		var convertedValue = Double(size)
//		var multiplyFactor = 0
//		let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
//		while convertedValue > 1024 {
//			convertedValue /= 1024
//			multiplyFactor += 1
//		}
//		return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
//	}
}
