//
//  File.swift
//  
//
//  Created by Alexey Turulin on 3/24/24.
//

import Foundation

struct AuthRequestDTO: Codable {
	var user: String
	var password: String
}

public struct AuthResponseDTO: Codable {
	public var access_token: String
}

public enum AuthError: Error {
	case serverError(Swift.Error)
	case noResponse
	case jsonError(Swift.Error)
}

public final class AuthService {

	public init() { }

	public func perform(completion: @escaping (Result<AuthResponseDTO, AuthError>) -> Void) {
		var url = URL(string: "https://practice.swiftbook.org/api")!
		url.appendPathComponent("/auth/login")

		let authRequest = AuthRequestDTO(user: "user@example.com", password: "123")

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = """
		{
			"login": "\(authRequest.user)",
			"password": "\(authRequest.password)"
		}
		""".data(using: .utf8)

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(AuthError.serverError(error)))
				return
			}

			guard let data = data else {
				completion(.failure(AuthError.noResponse))
				return
			}

			let decoder = JSONDecoder()

			do {
				let responseData = try decoder.decode(AuthResponseDTO.self, from: data)
				completion(.success(responseData))
			} catch {
				completion(.failure(AuthError.jsonError(error)))
			}
		}

		task.resume()
	}
}

// "/auth/login"
// {
//   "login": "user@example.com",
//   "password": "123"
// }
