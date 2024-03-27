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
	private var token: String?
	private var baseUrl: URL

	init(token: String? = nil, baseUrl: URL) {
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
			urlRequest.httpBody = body.data(using: .utf8)
		}

		return urlRequest
	}
}
