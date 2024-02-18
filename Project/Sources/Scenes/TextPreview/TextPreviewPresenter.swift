//
//  TextPreviewPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol ITextPreviewPresenter {
}

final class TextPreviewPresenter: ITextPreviewPresenter {

	// MARK: - Dependencies

	private weak var viewController: ITextPreviewViewController?

	// MARK: - Initialization

	init(viewController: TextPreviewViewController) {
		self.viewController = viewController
	}

	// MARK: - Public Methods

}