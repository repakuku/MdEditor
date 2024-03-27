//
//  NetworkManager.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum Path {
	case authorization

	var value: String {
		switch self {
		case .authorization:
			return "/auth/login"
		}
	}
}

protocol ILoginManager {
	func login(login: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class LoginManager: ILoginManager {

	private let session = URLSession.shared

	private let baseUrl = URL(string: "https://practice.swiftbook.org/api")! // swiftlint:disable:this force_unwrapping

	func login(login: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
		let requestBulder = RequestBuilder(baseUrl: baseUrl)
		let authService = AuthService(session: session, reqestBuilder: requestBulder)

		let authRequest = AuthRequestDTO(login: login, password: password)

		authService.perform(authRequest: authRequest) { result in
			switch result {
			case .success(let response):
				let keychainService = KeychainService(account: login)
				if !keychainService.saveToken(response.accessToken) {
					_ = keychainService.updateToken(response.accessToken)
				}
				completion(.success(()))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
