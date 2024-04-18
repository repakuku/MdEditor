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
	func fetchData(request: TagManagerModel.Request)
	func performAction(request: TagManagerModel.Request)
}

final class TagManagerInteractor: ITagManagerInteractor {

	// MARK: - Dependencies

	private let presenter: ITagManagerPresenter
	private let delegate: ITagManagerDelegate?

	// MARK: - Private Properties

	// MARK: - Initialization

	init(presenter: ITagManagerPresenter, delegate: ITagManagerDelegate) {
		self.presenter = presenter
		self.delegate = delegate
	}

	// MARK: - Public Methods

	func fetchData(request: TagManagerModel.Request) {
		// TODO: Replace
		if case .fetch(let searchTag) = request {
			let result = TagManagerModel.Response.SearchModel(
				fileUrl: Endpoints.documentTest,
				text: searchTag,
				lineNumber: 1
			)
			presenter.present(response: TagManagerModel.Response(result: [result]))
		}
	}

	func performAction(request: TagManagerModel.Request) {
		// TODO: Replace
		if case let .resultSelected(indexPath) = request {
			switch File.parse(url: Endpoints.documentTest) {
			case .success(let file):
				delegate?.openFile(file: file)
			case .failure(let error):
				print(error.localizedDescription) // swiftlint:disable:this print_using
			}
		}
	}
}
