//
//  RecentFile.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

final class RecentFile {
	let previewText: String
	let url: URL

	init(previewText: String, url: URL) {
		self.previewText = previewText
		self.url = url
	}
}
