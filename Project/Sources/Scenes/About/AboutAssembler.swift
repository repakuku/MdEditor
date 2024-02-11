//
//  AboutAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class AboutAssembler {
	func assembly(fileExplorer: FileExplorer, converter: IMarkdownToHTMLConverter) -> AboutViewController {
		let viewController = AboutViewController()
		let worker: IAboutWorker = AboutWorker(converter: converter)
		let presenter: IAboutPresenter = AboutPresenter(viewController: viewController, worker: worker)
		let interactor: IAboutInteractor = AboutInteractor(presenter: presenter, fileExplorer: fileExplorer)

		viewController.interactor = interactor

		return viewController
	}
}
