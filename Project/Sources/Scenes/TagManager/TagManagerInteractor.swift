//
//  TagManagerInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

protocol ITagManagerInteractor {
}

final class TagManagerInteractor: ITagManagerInteractor {

	// MARK: - Dependencies

	private let presenter: ITagManagerPresenter

	// MARK: - Private Properties

	// MARK: - Initialization

	init(presenter: ITagManagerPresenter) {
		self.presenter = presenter
	}

	// MARK: - Lifecycle

	// MARK: - Public Methods

}
