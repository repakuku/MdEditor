//
//  LoginWorker.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import Foundation

protocol ILoginWorker {

	/// Авторизация пользователя.
	/// - Parameters:
	///   - login: Логин пользователя.
	///   - password: Пароль пользователя.
	/// - Returns: Результат прохождения авторизации.
	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void)
}

enum LoginError: Error {
	case wrongLoginOrPassword
}

final class LoginWorker: ILoginWorker {

	private let networkManager = LoginManager()

	// MARK: - Public methods

	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void) {
		networkManager.login(login: login, password: password) { result in
			switch result {
			case .success:
				completion(.success(()))
			case .failure:
				completion(.failure(.wrongLoginOrPassword))
			}
		}
	}
}

final class StubLoginWorker: ILoginWorker {
	func login(login: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void) {
		completion(.success(()))
	}
}
