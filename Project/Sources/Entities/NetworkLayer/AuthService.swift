//
//  AuthService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct AuthRequestDTO: Codable {
	var login: String
	var password: String
}

struct AuthResponseDTO: Codable {
	var accessToken: String
}

protocol IAuthService {
	func perform(authRequest: AuthRequestDTO, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
}

final class AuthService: IAuthService {

	private let session: URLSession
	private let requestBuilder: IRequestBuilder

	init (session: URLSession, reqestBuilder: IRequestBuilder) {
		self.session = session
		self.requestBuilder = reqestBuilder
	}

	func perform(authRequest: AuthRequestDTO, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {

		let headerField = HttpHeaderField.contentType(ContentType.json)
		let header = [
			headerField.key: headerField.value
		]

		let bodyData = try? JSONEncoder().encode(authRequest)

		let request = NetworkRequest(
			path: Path.authorization.value,
			method: .post,
			header: header,
			body: String(data: bodyData ?? Data(), encoding: .utf8) ?? ""
		)

		let urlRequest = requestBuilder.build(forRequest: request)

		let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
			if let error = error {
				completion(.failure(AuthError.serverError(error)))
				return
			}

			guard let data = data else {
				completion(.failure(AuthError.noResponse))
				return
			}

			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			do {
				let responseData = try decoder.decode(AuthResponseDTO.self, from: data)
				completion(.success(responseData))
			} catch {
				completion(.failure(AuthError.jsonError(error)))
			}
		}

		task.resume()
	}

	enum AuthError: Error {
		case serverError(Swift.Error)
		case noResponse
		case jsonError(Swift.Error)
	}
}
