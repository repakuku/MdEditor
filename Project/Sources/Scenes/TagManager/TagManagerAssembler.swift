//
//  TagManagerAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

final class TagManagerAssembler {
	func assembly(delegate: ITagManagerDelegate) -> TagManagerViewController {
		let viewController = TagManagerViewController()
		let presenter = TagManagerPresenter(viewController: viewController)
		let interactor = TagManagerInteractor(presenter: presenter, delegate: delegate)
		viewController.interactor = interactor

		return viewController
	}
}
