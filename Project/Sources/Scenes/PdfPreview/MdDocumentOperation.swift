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

typealias MdDocumentOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)

final class MdDocumentOperation: Operation {
	
	private let url: URL
	private let completion: MdDocumentOperationCompletion?
	
	var document: MdDocument?
	
	init(url: URL, completion: MdDocumentOperationCompletion? = nil) {
		self.url = url
		self.completion = completion
		super.init()
	}
	
	override func main() {
		guard !isCancelled else { return }
		let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] (data, response, error) in
			
			// Если при инициализации класса будет передано замыкание,
			// то обработка результата будет происходить в нём.
			// По сути - это делегат.
			if let completion = self?.completion {
				completion(data, response, error)
				return
			}
			
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			guard let data = data, let body = String(data: data, encoding: .utf8) else { return }
			
			self?.document = MdDocument(name: self?.url.lastPathComponent ?? "", body: body)
		}
		task.resume()
	}
}
