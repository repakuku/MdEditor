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

	// MARK: - Private properties

	private let delegate: ISearchManagerDelegate?

	// MARK: - Initialization

	init(presenter: ISearchManagerPresenter, delegate: ISearchManagerDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	func fetchData(request: SearchManagerModel.Request) {
		if case let .searchButtonPressed(searchText) = request {
			let result = SearchManagerModel.Response.SearchModel(
				fileUrl: Endpoints.documentTest,
				text: "Test",
				lineNumber: 1
			)
			presenter.present(response: SearchManagerModel.Response(results: [result]))
		}
	}

	func performAction(request: SearchManagerModel.Request) {
		if case let .resultSelected(indexPath) = request {
			switch File.parse(url: Endpoints.documentTest) {
			case .success(let file):
				delegate?.openFile(file: file)
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}
