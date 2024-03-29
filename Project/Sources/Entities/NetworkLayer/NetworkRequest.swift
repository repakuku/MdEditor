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
	var body: Data? { get }
}

enum HttpMethod: String {
	case get = "GET"
	case post = "POST"
}

enum HttpHeaderField {
	case contentType(ContentType)
	case authorization(Token)
	case contentDisposition(name: String, fileName: String)

	var key: String {
		switch self {
		case .contentType:
			return "Content-Type"
		case .authorization:
			return "Authorization"
		case .contentDisposition:
			return "Content-Disposition"
		}
	}

	var value: String {
		switch self {
		case .contentType(let contentType):
			return contentType.value
		case .authorization(let token):
			return "Bearer \(token.rawValue)"
		case .contentDisposition(let name, let fileName):
			return "form-data; name=\"\(name)\"; filename=\"\(fileName)\""
		}
	}
}

enum ContentType {
	case json
	case multipart(boundary: String)
	case markdown

	var value: String {
		switch self {
		case .json:
			return "application/json"
		case .multipart(let boundary):
			return "multipart/form-data; boundary=----\(boundary)"
		case .markdown:
			return "text/markdown"
		}
	}
}

struct NetworkRequest: INetworkRequest {

	static let baseURL = URL(string: "https://practice.swiftbook.org")! // swiftlint:disable:this force_unwrapping

	var path: String
	var method: HttpMethod
	var header: [String: String]
	var body: Data?
}

enum ResponseCode {
	static let informationalCodes = 100..<200
	static let successCodes = 200..<300
	static let redirectCodes = 300..<400
	static let clientErrorCodes = 400..<500
	static let serverErorCodes = 500..<600
}
