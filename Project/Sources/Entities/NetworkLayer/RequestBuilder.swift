//
//  RequestBuilder.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IRequestBuilder {
	func build(forRequest request: INetworkRequest) -> URLRequest
}

struct RequestBuilder: IRequestBuilder {
	private var token: Token?
	private var baseUrl: URL

	init(token: Token? = nil, baseUrl: URL) {
		self.token = token
		self.baseUrl = baseUrl
	}

	func build(forRequest request: INetworkRequest) -> URLRequest {
		let url = baseUrl.appendingPathComponent(request.path)
		var urlRequest = URLRequest(url: url)

		urlRequest.httpMethod = request.method.rawValue
		urlRequest.allHTTPHeaderFields = request.header

		if let token = token {
			let header = HttpHeaderField.authorization(token)
			urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
		}

		if let body = request.body {
			urlRequest.httpBody = body
		}

		return urlRequest
	}
}
