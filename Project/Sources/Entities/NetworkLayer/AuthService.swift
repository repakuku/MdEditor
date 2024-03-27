//
//  AuthService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct AuthRequestDTO: Codable {
	let login: String
	let password: String
}

struct AuthResponseDTO: Codable {
	let accessToken: String
}

protocol IAuthService {
	func login(login: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthService: IAuthService {

	private let session = URLSession.shared

	private let baseUrl = URL(string: "https://practice.swiftbook.org")! // swiftlint:disable:this force_unwrapping

	func login(login: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
		let requestBulder = RequestBuilder(baseUrl: baseUrl)
		let networkSevice = NetworkService(session: session, requestBuilder: requestBulder)

		let headerField = HttpHeaderField.contentType(ContentType.json)
		let header = [
			headerField.key: headerField.value
		]

		let authRequest = AuthRequestDTO(login: login, password: password)
		let bodyData = try? JSONEncoder().encode(authRequest)

		let request = NetworkRequest(
			path: PathComponent.login.path,
			method: .post,
			header: header,
			body: String(data: bodyData ?? Data(), encoding: .utf8) ?? ""
		)

		networkSevice.perform(request) { (result: Result<AuthResponseDTO, HttpNetworkServiceError>) in
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
