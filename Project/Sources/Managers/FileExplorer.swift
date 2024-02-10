//
//  FileExplorer.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/6/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFile {
	var url: URL { get set }
}

struct File: IFile {
	var url: URL
}

protocol IFileExplorer {
	func getRecentFiles() -> [IFile]
}

final class FileExplorer: IFileExplorer {

	// MARK: - Dependencies

	private let fileManager: FileManager

	// MARK: - Private Properties

	private var files: [IFile] = []
	private var recentFiles: [IFile] = []

	// MARK: - Initialization

	init(fileManager: FileManager) {
		self.fileManager = fileManager
	}

	// MARK: - Public Methods

	func getRecentFiles() -> [IFile] {
		return recentFiles
	}

	// MARK: - Private Methods

}
