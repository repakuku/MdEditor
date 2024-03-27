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

final class FileService {

	private let session = URLSession.shared

	private let baseUrl = URL(string: "https://practice.swiftbook.org")! // swiftlint:disable:this force_unwrapping

	func getList() {
		guard let token = KeychainService(account: "repakuku@icloud.com").getToken() else {
			return
		}

		let requestBuilder = RequestBuilder(token: token, baseUrl: baseUrl)
		let networkSevice = NetworkService(session: session, requestBuilder: requestBuilder)

		let headerField = HttpHeaderField.authorization(token)
		let header = [
			headerField.key: headerField.value
		]

		let request = NetworkRequest(
			path: PathComponent.files.path,
			method: .get,
			header: header
		)

		networkSevice.perform(request) { (result: Result<[FilesResponseDataDTO.Item], HttpNetworkServiceError>) in
			switch result {
			case .success(let response):
				print(response)
			case .failure(let error):
				print(error)
			}
		}
	}
}
