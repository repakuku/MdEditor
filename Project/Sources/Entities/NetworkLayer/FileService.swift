//
//  FileService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct FilesResponseDataDTO: Codable {

	let items: [Item]

	struct Item: Codable {
		let id: String
		let originalName: String
		let size: Int
		let createdAt: String
		let updatedAt: String
		let url: String

		enum CodingKeys: String, CodingKey {
			case id = "_id"
			case originalName = "originalName"
			case size = "size"
			case createdAt = "createdAt"
			case updatedAt = "updatedAt"
			case url = "url"
		}
	}
}

struct UploadResponseDTO: Codable {
  let url: String
  let originalName: String
//  "size": 2460,
//  "contentType": "text/markdown",
//  "createdAt": "2024-03-27T21:17:21.902Z",
//  "updatedAt": "2024-03-27T21:17:21.902Z",
//  "hash": "f90556a597e25c544148f70a7951844b3bf377d7d6954869c7f36ae5996eed77",
//  "_id": "66048ce1e6cda734368c5fca",
//  "__v": 0
}

final class FileService {

	private let session = URLSession.shared
	private let requestBuilder: IRequestBuilder
	private let networkService: INetworkService

	private let token: Token
	private let baseUrl = URL(string: "https://practice.swiftbook.org")! // swiftlint:disable:this force_unwrapping

	init(token: Token) {
		self.token = token

		requestBuilder = RequestBuilder(token: token, baseUrl: baseUrl)
		networkService = NetworkService(session: session, requestBuilder: requestBuilder)
	}

	func getFiles(completion: @escaping (Result<FilesResponseDataDTO, HttpNetworkServiceError>) -> Void) {

		let headerField = HttpHeaderField.authorization(token)
		let header = [
			headerField.key: headerField.value
		]

		let request = NetworkRequest(
			path: PathComponent.files.path,
			method: .get,
			header: header
		)

		networkService.perform(request) { (result: Result<[FilesResponseDataDTO.Item], HttpNetworkServiceError>) in
			switch result {
			case .success(let files):
				let response = FilesResponseDataDTO(items: files)
				completion(.success(response))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func upload(file: File, completion: @escaping (Result<UploadResponseDTO, HttpNetworkServiceError>) -> Void) {

		let authHeader = HttpHeaderField.authorization(token)

		let boundary = UUID().uuidString
		let multipartContentTypeHeader = HttpHeaderField.contentType(.multipart(boundary: boundary))

		let contentDispositionHeader = HttpHeaderField.contentDisposition(name: "file", fileName: file.name)
		let markdownContentTypeHeader = HttpHeaderField.contentType(.markdown)

		let formData = NSMutableData()
		formData.append("------\(boundary)\r\n".data(using: .utf8)!) // swiftlint:disable:this force_unwrapping
		formData.append(
			// swiftlint:disable:next force_unwrapping
			"\(contentDispositionHeader.key): \(contentDispositionHeader.value)\r\n".data(using: .utf8)!
		)
		// swiftlint:disable:next force_unwrapping
		formData.append("\(markdownContentTypeHeader.key): \(markdownContentTypeHeader.value)\r\n".data(using: .utf8)!)

		formData.append(file.contentOfFile()!) // swiftlint:disable:this force_unwrapping

		formData.append("------\(boundary)--\r\n".data(using: .utf8)!) // swiftlint:disable:this force_unwrapping

		let header = [
			authHeader.key: authHeader.value,
			multipartContentTypeHeader.key: multipartContentTypeHeader.value
		]

		let request = NetworkRequest(
			path: PathComponent.upload.path,
			method: .post,
			header: header,
			body: formData as Data
		)

		networkService.perform(request) { (result: Result<UploadResponseDTO, HttpNetworkServiceError>) in
			switch result {
			case .success(let response):
				completion(.success(response))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
