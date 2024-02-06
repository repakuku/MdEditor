//
//  StartInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IStartInteractor {
	func fetchData()
}

final class StartInteractor: IStartInteractor {

	// MARK: - Dependencies

	private var presenter: IStartPresenter?

	// MARK: - Initialization

	init(presenter: IStartPresenter? = nil) {
		self.presenter = presenter
	}

	// MARK: - Public Methods

	func fetchData() {
		presenter?.present()
	}
}
