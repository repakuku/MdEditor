//
//  FileExplorer.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/6/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFile {
	var name: String { get set }
}

struct File: IFile {
	var name = ""
}

protocol IFileExplorer {
	func getFiles() -> [IFile]
}

final class FileExplorer: IFileExplorer {

	private var files: [IFile]

	init(files: [IFile] = []) {
		self.files = files
	}

	func getFiles() -> [IFile] {
		files
	}
}

final class FileExplorerStub: IFileExplorer {
	func getFiles() -> [IFile] {
		[
			File(name: "File1"),
			File(name: "File2"),
			File(name: "File3"),
			File(name: "File4"),
			File(name: "File5")
		]
	}
}
