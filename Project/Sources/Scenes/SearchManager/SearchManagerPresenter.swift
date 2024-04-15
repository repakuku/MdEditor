//
//  SearchManagerPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ISearchManagerPresenter {
	func present(response: SearchManagerModel.Response)
}

final class SearchManagerPresenter: ISearchManagerPresenter {

	// MARK: - Dependencies

	private let viewController: ISearchManagerViewController

	// MARK: - Initialization

	init(viewController: ISearchManagerViewController) {
		self.viewController = viewController
	}

	func present(response: SearchManagerModel.Response) {
		let results: [SearchManagerModel.ViewModel.SearchModel] = response.results.map {
			SearchManagerModel.ViewModel.SearchModel(
				fileName: $0.fileUrl.lastPathComponent,
				text: $0.text
			)
		}
		let viewModel = SearchManagerModel.ViewModel(results: results)
		viewController.render(viewModel: viewModel)
	}
}
