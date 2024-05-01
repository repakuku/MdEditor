//
//  FileManagerInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFileManagerDelegate: AnyObject {
	func openFolder(file: File)
	func openFile(file: File)
}

protocol IFileManagerInteractor {
	func fetchData()
	func performAction(request: FileManagerModel.Request)
}

final class FileManagerInteractor: IFileManagerInteractor {

	// MARK: - Dependencies

	private let presenter: IFileManagerPresenter
	private let fileExplorer: IFileExplorer
	private let delegate: IFileManagerDelegate?

	// MARK: - Private properties

	private var fileList: FileManagerModel.Response! // swiftlint:disable:this implicitly_unwrapped_optional
	private let currentFile: File?

	// MARK: - Initialization

	init(
		presenter: IFileManagerPresenter,
		fileExplorer: IFileExplorer,
		delegate: IFileManagerDelegate,
		file: File?
	) {
		self.presenter = presenter
		self.fileExplorer = fileExplorer
		self.delegate = delegate
		self.currentFile = file
	}

	// MARK: - Public Methods

	func fetchData() {
		if let currentFile {
			switch fileExplorer.contentOfFolder(at: currentFile.url) {
			case .success(let files):
				fileList = FileManagerModel.Response(currentFile: currentFile, files: files)
			case .failure:
				break
			}
		} else {
			var files = [File]()

			if case .success(let file) = File.parse(url: Endpoints.examples) {
				files.append(file)
			}

			if case .success(let file) = File.parse(url: Endpoints.documents) {
				files.append(file)
			}

			fileList = FileManagerModel.Response(currentFile: nil, files: files)
		}

		presenter.present(response: fileList)
	}

	func performAction(request: FileManagerModel.Request) {
		switch request {
		case .fileSelected(let indexPath):
			let selectedFile = fileList.files[min(indexPath.row, fileList.files.count - 1)]
			if selectedFile.isFolder {
				delegate?.openFolder(file: selectedFile)
			} else {

				delegate?.openFile(file: selectedFile)

				if let token = KeychainService(account: "repakuku@icloud.com").getToken() {
					FileService(token: token).upload(file: selectedFile) { _ in
					}
				}
			}
		}
	}
}
