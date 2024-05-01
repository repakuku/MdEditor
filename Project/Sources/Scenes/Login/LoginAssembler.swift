//
//  LoginAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import UIKit

/// Assembles components for the login module.
final class LoginAssembler {

	/// Assemble the login module.
	/// - Parameter loginResultClosure: A closure that notifies about the result of the login process.
	/// - Returns: A configured instance of 'LoginViewConroller'.
	func assembly(loginResultClosure: LoginResultClosure?) -> LoginViewController {
		let viewController = LoginViewController()
		let presenter = LoginPresenter(
			viewController: viewController,
			loginResultClosure: loginResultClosure
		)
		let worker = LoginWorker()
		let interactor = LoginInteractor(
			presenter: presenter,
			worker: worker
		)

		viewController.interactor = interactor

		return viewController
	}
}
