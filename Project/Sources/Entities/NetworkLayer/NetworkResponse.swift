//
//  NetworkResponse.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class NetworkResponse {
	let result: Result<Data?, HttpNetworkServiceError>

	init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
		guard let response = response as? HTTPURLResponse else {
			self.result = .failure(.invalidResponse(response))
			return
		}

		guard let status = ResponseStatus(rawValue: response.statusCode), status.isSuccess else {
			self.result = .failure(.invalidStatusCode(response.statusCode, data))
			return
		}

		if let error = error {
			self.result = .failure(.networkError(error))
		} else {
			self.result = .success(data)
		}
	}
}

enum ResponseStatus {
	case success(Int)
	case redirect(Int)

	init?(rawValue: Int) {
		if ResponseCode.successCodes.contains(rawValue) {
			self = .success(rawValue)
		} else if ResponseCode.redirectCodes.contains(rawValue) {
			self = .redirect(rawValue)
		} else {
			return nil
		}
	}

	var isSuccess: Bool {
		switch self {
		case .success:
			return true
		default:
			return false
		}
	}
}
