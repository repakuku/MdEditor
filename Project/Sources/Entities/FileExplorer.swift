//
//  FileExplorer.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/6/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFileExplorer {
	func contentOfFolder(at url: URL) -> Result<[File], Error>
	func createFolder(at url: URL, withName name: String) -> Result<File, Error>
	func createNewFile(at url: URL, fileName: String) -> Result<File, Error>
}

final class FileExplorer: IFileExplorer {

	enum FileExplorerError: Error {
		case wrongAttribute
	}

	// MARK: - Dependencies

	private let fileManager = FileManager.default

	// MARK: - Private Properties

	private let fileEncoding = String.Encoding.utf8

	// MARK: - Public Methods

	func contentOfFolder(at url: URL) -> Result<[File], Error> {

		do {
			let fileUrls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
			var files = [File]()
			for fileUrl in fileUrls {
				let file = File.parse(url: fileUrl)
				switch file {
				case .success(let file):
					files.append(file)
				case .failure(let error):
					return .failure(error)
				}
			}
			return .success(files)
		} catch {
			return .failure(error)
		}
	}

	func createFolder(at url: URL, withName name: String) -> Result<File, Error> {
		.failure(FileExplorerError.wrongAttribute)
	}

	func createNewFile(at url: URL, fileName: String) -> Result<File, Error> {
		.failure(FileExplorerError.wrongAttribute)
	}
}
