//
//  AboutPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IAboutPresenter {
	func present(response: AboutModel.Response)
}

final class AboutPresenter: IAboutPresenter {

	// MARK: - Dependencies

	private weak var viewController: AboutViewController?
	private var worker: IAboutWorker

	// MARK: - Initialization

	init(viewController: AboutViewController, worker: IAboutWorker) {
		self.viewController = viewController
		self.worker = worker
	}

	// MARK: - Public Methods

	func present(response: AboutModel.Response) {
		let html = worker.convert(response.text)
		let viewModel = AboutModel.ViewModel(html: html)

		viewController?.render(viewModel: viewModel)
	}
}
