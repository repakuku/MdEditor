//
//  LoginCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/14/24.
//

import UIKit

protocol ILoginCoordinator: ICoordinator {
	var finishFlow: (() -> Void)? { get set }
}

final class LoginCoordinator: ILoginCoordinator {

	// MARK: - Internal properties

	var finishFlow: (() -> Void)?

	// MARK: - Dependencies

	private let navigationController: UINavigationController

	// MARK: - Initialization

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	// MARK: - Internal methods

	func start() {
		showLoginScene()
	}
}

// MARK: - Private methods

private extension LoginCoordinator {
	func showLoginScene() {
		let viewController = LoginAssembler().assembly { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success:
				finishFlow?()
			case .failure(let error):
				showError(message: error.localizedDescription)
			}
		}
		navigationController.pushViewController(viewController, animated: true)
	}

	func showError(message: String) {
		let alert = UIAlertController(title: L10n.Error.text, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: L10n.Ok.text, style: .default)
		alert.addAction(action)
		navigationController.present(alert, animated: true, completion: nil)
	}
}
