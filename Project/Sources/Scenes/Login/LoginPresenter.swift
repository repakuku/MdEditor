//
//  LoginPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import Foundation

/// Protocol defining the responsibilities of a login presenter.
protocol ILoginPresenter {

	/// Presents the response from a login attempt.
	/// - Parameter responce: The result of the login attempt.
	func present(responce: LoginModel.Response)
}

/// Closure type for handling the result of a login operation.
typealias LoginResultClosure = (Result<Void, LoginError>) -> Void

/// A presenter class responsible for handling the presentation logic of the login process.
final class LoginPresenter: ILoginPresenter {

	// MARK: - Dependencies

	private weak var viewController: ILoginViewController?
	private let loginResultClosure: LoginResultClosure?

	// MARK: - Initialization
	
	/// Initializes a new instance of 'LoginPresenter.'
	/// - Parameters:
	///   - viewController: The view controller that handles login UI interactions.
	///   - loginResultClosure: A closure that is executed with the result of the login operation.
	init(viewController: ILoginViewController?, loginResultClosure: LoginResultClosure?) {
		self.viewController = viewController
		self.loginResultClosure = loginResultClosure
	}

	// MARK: - Public methods
	
	/// Presents the response from a login attempt.
	/// - Parameter responce: The result of the login attempt.
	func present(responce: LoginModel.Response) {
		loginResultClosure?(responce.result)
	}
}

extension LoginError: LocalizedError {
	var errorDescription: String? {
		L10n.LoginError.wrongLoginOrPassword
	}
}
