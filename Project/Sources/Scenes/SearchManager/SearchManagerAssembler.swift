//
//  SearchManagerAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class SearchManagerAssembler {

	// MARK: - Public methods
	func assembly(delegate: ISearchManagerDelegate) -> SearchManagerViewController {
		let viewController = SearchManagerViewController()
		let presenter = SearchManagerPresenter(viewController: viewController)
		let interactor = SearchManagerInteractor(presenter: presenter, delegate: delegate)
		viewController.interactor = interactor

		return viewController
	}
}
