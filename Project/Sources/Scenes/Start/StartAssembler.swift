//
//  StartAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

final class StartAssembler {
	func assembly() -> StartViewController {
		let viewController = StartViewController()
		let presenter = StartPresenter(viewController: viewController)
		let interactor = StartInteractor(presenter: presenter)
		viewController.interactor = interactor

		return viewController
	}
}
