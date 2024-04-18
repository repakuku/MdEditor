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
	private let searchService = SearchService()

	// MARK: - Private properties

	private let delegate: ISearchManagerDelegate?

	// MARK: - Initialization

	init(presenter: ISearchManagerPresenter, delegate: ISearchManagerDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	func fetchData(request: SearchManagerModel.Request) {
		if case let .fetch(searchText) = request {
			let result = searchService.searchTextInFiles(atPath: Endpoints.examples, text: searchText)
			let searchResult: [SearchManagerModel.Response.SearchModel] = result.map {
				SearchManagerModel.Response.SearchModel(
					fileUrl: $0.fileUrl,
					text: $0.lineText,
					lineNumber: $0.lineNumber
				)
			}
			let response = SearchManagerModel.Response(result: searchResult)
			presenter.present(response: response)
		}
	}

	func performAction(request: SearchManagerModel.Request) {
		// TODO: Replace
		if case .resultSelected(let indexPath) = request {
//			delegate?.openFile(file: file)
		}
	}
}
