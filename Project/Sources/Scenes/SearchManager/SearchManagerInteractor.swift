//
//  SearchManagerInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ISearchManagerDelegate: AnyObject {
	func openFile(file: File)
}

protocol ISearchManagerInteractor {
	func fetchData(request: SearchManagerModel.Request)
	func performAction(request: SearchManagerModel.Request)
}

final class SearchManagerInteractor: ISearchManagerInteractor {

	// MARK: - Dependencies

	private let presenter: ISearchManagerPresenter

	private let searchService = FreqWordService()

	// MARK: - Private properties

	private let delegate: ISearchManagerDelegate?

	private var files: [File] = []

	// MARK: - Initialization

	init(presenter: ISearchManagerPresenter, delegate: ISearchManagerDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	func fetchData(request: SearchManagerModel.Request) {
		if case let .fetch(searchText) = request {
			let freqWords = searchService.freqWordsInFiles(atPath: Endpoints.examples)
			let searchResult = searchService.searchWord(searchText, wordCount: freqWords)

			let result = searchResult.keys.map {
				SearchManagerModel.Response.SearchModel(
					fileUrl: $0,
					text: searchText,
					lineNumber: searchResult[$0] ?? 0
				)
			}

			result.forEach {
				if case let .success(file) = File.parse(url: $0.fileUrl) {
					files.append(file)
				}
			}

			let response = SearchManagerModel.Response(result: result)
			presenter.present(response: response)
		}
	}

	func performAction(request: SearchManagerModel.Request) {
		if case .resultSelected(let indexPath) = request {
			if indexPath.row < files.count {
				delegate?.openFile(file: files[indexPath.row])
			}
		}
	}
}
