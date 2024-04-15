//
//  MdDocumentSaverOperation.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/4/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class MdDocumentSaverOperation: Operation {
	var document: MdDocument?

	init(document: MdDocument? = nil) {
		self.document = document
		super.init()
	}

	override func main() {

		let dependencyDocument = dependencies.compactMap { ($0 as? IMdDocumentDataProvider)?.document }.first

		guard let document = document ?? dependencyDocument else { return }

		guard !isCancelled else { return }

		let fileManager = FileManager.default

		guard let documnetUrl = try? fileManager.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		) else {
			return
		}

		let fileUrl = documnetUrl.appendingPathComponent(document.name)

		do {
			try document.body.write(to: fileUrl, atomically: true, encoding: .utf8)
		} catch {
			// error handling
		}
	}
}

extension MdDocumentSaverOperation: IMdDocumentDataProvider { }
