//
//  TagManagerPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ITagManagerPresenter {
	func present(response: TagManagerModel.Response)
}

final class TagManagerPresenter: ITagManagerPresenter {

	// MARK: - Dependencies

	private let viewController: TagManagerViewController

	// MARK: - Private Properties

	// MARK: - Initialization

	init(viewController: TagManagerViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

	func present(response: TagManagerModel.Response) { }
}
