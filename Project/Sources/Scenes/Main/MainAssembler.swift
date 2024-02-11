//
//  MainAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class MainAssembler {
	func assembly(fileExplorer: FileExplorer, closure: (() -> Void)?) -> MainViewController {
		let viewController = MainViewController()
		let presenter = MainPresenter(
			viewController: viewController,
			fileExplorer: fileExplorer,
			closure: closure
		)
		let interactor = MainInteractor(presenter: presenter)
		viewController.interactor = interactor

		return viewController
	}
}
