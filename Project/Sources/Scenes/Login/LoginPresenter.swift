//
//  LoginPresenter.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import Foundation

// TODO: Translate documentation
protocol ILoginPresenter {

	/// Отображение экрана со авторизации.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(responce: LoginModel.Response)
}

typealias LoginResultClosure = (Result<Void, LoginError>) -> Void

// TODO: Translate documentation
final class LoginPresenter: ILoginPresenter {

	// MARK: - Dependencies

	private weak var viewController: ILoginViewController?
	private var loginResultClosure: LoginResultClosure?

	// MARK: - Initialization

	init(viewController: ILoginViewController?, loginResultClosure: LoginResultClosure?) {
		self.viewController = viewController
		self.loginResultClosure = loginResultClosure
	}

	// MARK: - Public methods

	/// Отображение экрана со авторизации.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(responce: LoginModel.Response) {
		loginResultClosure?(responce.result)
	}
}

extension LoginError: LocalizedError {
	var errorDescription: String? {
		L10n.LoginError.wrongLoginOrPassword
	}
}
