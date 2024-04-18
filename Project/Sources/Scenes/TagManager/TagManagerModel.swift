//
//  TagManagerModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

enum TagManagerModel {

	enum Request {
		case fetch(searchTag: String)
		case resultSelected(indexPath: IndexPath)
	}

	struct Response {
		let result: [SearchModel]

		struct SearchModel {
			let fileUrl: URL
			let text: String
			let lineNumber: Int
		}
	}

	struct ViewModel {
		let result: [SearchModel]

		struct SearchModel {
			let text: String
		}
	}
}
