//
//  MdDocumentOperation.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/22/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct MdDocument {
	let name: String
	let body: String
}

protocol IMdDocumentDataProvider {
	var document: MdDocument? { get }
}

typealias MdDocumentOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)

final class MdDocumentDownloadOperation: Operation {

	private let url: URL
	private let completion: MdDocumentOperationCompletion?
	private var task: URLSessionDataTask?

	var document: MdDocument?

	init(url: URL, completion: MdDocumentOperationCompletion? = nil) {
		self.url = url
		self.completion = completion
		super.init()
	}

	override func main() {
		guard !isCancelled else { return }

		document = nil

		let semaphore = DispatchSemaphore(value: 0)

		task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in

			defer { semaphore.signal() }

			guard let self = self else {
				return
			}

			if let completion = self.completion {
				completion(data, response, error)
				return
			}

			if error != nil {
				return
			}

			guard let data = data, let body = String(data: data, encoding: .utf8) else {
				return
			}

			self.document = MdDocument(name: self.url.lastPathComponent, body: body)
		}
		task?.resume()
		semaphore.wait()
	}

	override func cancel() {
		super.cancel()
		task?.cancel()
	}
}

extension MdDocumentDownloadOperation: IMdDocumentDataProvider { }
