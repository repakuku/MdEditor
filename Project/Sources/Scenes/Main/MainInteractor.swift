//
//  MainInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IMainInteractor {
	func fetchData()
	func buttonAboutPressed()
}

final class MainInteractor: IMainInteractor {

	// MARK: - Dependencies

	private var presenter: IMainPresenter?

	// MARK: - Initialization

	init(presenter: IMainPresenter? = nil) {
		self.presenter = presenter
	}

	// MARK: - Public Methods

	func fetchData() {
		#warning("TODO: fetch data here")
		presenter?.present()
	}

	func buttonAboutPressed() {
		presenter?.presentAboutScreen()
	}
}
