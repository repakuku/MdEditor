//
//  NetworkRequest.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol INetworkRequest {
	var path: String { get }
	var method: HttpMethod { get }
	var header: [String: String] { get }
	var body: String? { get }
}

enum HttpMethod: String {
	case get = "GET"
	case post = "POST"
}

enum HttpHeaderField {
	case contentType(ContentType)
	case authorization(String)

	var key: String {
		switch self {
		case .contentType:
			return "Content-Type"
		case .authorization:
			return "Authorization"
		}
	}

	var value: String {
		switch self {
		case .contentType(let contentType):
			return contentType.value
		case .authorization(let token):
			return "Bearer \(token)"
		}
	}
}

enum ContentType {
	case json

	var value: String {
		switch self {
		case .json:
			return "application/json"
		}
	}
}

struct NetworkRequest: INetworkRequest {
	var path: String
	var method: HttpMethod
	var header: [String: String]
	var body: String?
}

public enum ResponseCode {
	static let informationalCodes = 100..<200
	static let successCodes = 200..<300
	static let redirectCodes = 300..<400
	static let clientErrorCodes = 400..<500
	static let serverErorCodes = 500..<600
}
