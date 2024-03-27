//
//  NetworkService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class NetworkService {
	private let session: URLSession
	private let requestBuilder: IRequestBuilder

	init(session: URLSession, requestBuilder: IRequestBuilder) {
		self.session = session
		self.requestBuilder = requestBuilder
	}

	func perform<T: Codable>(
		_ request: INetworkRequest,
		completion: @escaping (Result<T, HttpNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.build(forRequest: request)
		perform(urlRequest: urlRequest) { result in
			switch result {
			case .success(let data):
				guard let data = data else {
					completion(.failure(.noData))
					return
				}

				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase

				do {
					let object = try decoder.decode(T.self, from: data)
					completion(.success(object))
				} catch {
					completion(.failure(.failedToDecodeResponse(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func perform(
		_ request: INetworkRequest,
		completion: @escaping (Result<Data?, HttpNetworkServiceError>) -> Void
	) {
		let urlRequest = requestBuilder.build(forRequest: request)
		perform(urlRequest: urlRequest, completion: completion)
	}

	func perform(urlRequest: URLRequest, completion: @escaping (Result<Data?, HttpNetworkServiceError>) -> Void) {
		let task = session.dataTask(with: urlRequest) { data, response, error in
			let networkResponse = NetworkResponse(data: data, response: response, error: error)
			completion(networkResponse.result)
		}
		task.resume()
	}
}

public enum HttpNetworkServiceError: Error {
	case networkError(Error)
	case invalidResponse(URLResponse?)
	case invalidStatusCode(Int, Data?)
	case noData
	case failedToDecodeResponse(Error)
}
