//
//  TextPreviewInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ITextPreviewInteractor {
	func fetchData()
}

final class TextPreviewInteractor: ITextPreviewInteractor {

	// MARK: - Dependencies

	private let presenter: ITextPreviewPresenter

	// MARK: - Initialization

	init(presenter: ITextPreviewPresenter) {
		self.presenter = presenter
	}

	// MARK: - Public Methods

	func fetchData() {
	}
}
