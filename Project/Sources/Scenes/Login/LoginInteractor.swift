//
//  LoginInteractor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import Foundation

/// Protocol defining the interface for an interactor in the login flow.
protocol ILoginInteractor {

	/// Initiates a login process with the provided request parameters.
	/// - Parameter request: The login request containing user credentials.
	func login(request: LoginModel.Request)
}

/// An interactor class that handles the login logic.
final class LoginInteractor: ILoginInteractor {

	// MARK: - Dependencies

	private let presenter: ILoginPresenter
	private let worker: ILoginWorker

	// MARK: - Initialization
	
	/// Initializes a new 'LoginInteractor' instance.
	/// - Parameters:
	///   - presenter: The presenter that will handle presenting data.
	///   - worker: The worker that will handle the actual login logic.
	init(presenter: ILoginPresenter, worker: ILoginWorker) {
		self.presenter = presenter
		self.worker = worker
	}

	// MARK: - Public methods
	
	/// Initiates a login process with the provided request parameters.
	/// - Parameter request: The login request containing user credentials.
	func login(request: LoginModel.Request) {
		worker.login(login: request.login, password: request.password) { result in

			DispatchQueue.main.async {
				let response = LoginModel.Response(result: result)
				self.presenter.present(responce: response)
			}
		}
	}
}
