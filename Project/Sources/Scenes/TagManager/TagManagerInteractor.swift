//
//  TagManagerInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

protocol ITagManagerDelegate: AnyObject {
	func openFile(file: File)
}

protocol ITagManagerInteractor {
	func fetchData()
	func performAction(request: TagManagerModel.Request)
}

final class TagManagerInteractor: ITagManagerInteractor {

	// MARK: - Dependencies

	private let presenter: ITagManagerPresenter
	private let delegate: ITagManagerDelegate?
	private let extractTagService = ExtractTagService()

	// MARK: - Private Properties

	// MARK: - Initialization

	init(presenter: ITagManagerPresenter, delegate: ITagManagerDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	// MARK: - Public Methods

	func fetchData() {
		let result = extractTagService.extractTagFromFiles(atPath: Endpoints.examples)
		let response = TagManagerModel.Response(result: result)
		presenter.present(response: response)
	}

	func performAction(request: TagManagerModel.Request) {
		// TODO: Complete
	}
}
