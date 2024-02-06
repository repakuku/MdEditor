//
//  StartPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IStartPresenter {
	func present()
}

final class StartPresenter: IStartPresenter {

	// MARK: - Dependencies

	private weak var viewController: IStartViewController?

	// MARK: - Initialization

	init(viewController: IStartViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

	func present() {
	}
}
