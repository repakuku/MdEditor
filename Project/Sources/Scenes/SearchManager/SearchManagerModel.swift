//
//  SearchManagerModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum SearchManagerModel {

	enum Request {
		case searchButtonPressed(searchText: String)
		case resultSelected(indexPath: IndexPath)
	}

	struct Response {
		let results: [SearchModel]

		struct SearchModel {
			let fileUrl: URL
			let text: String
			let lineNumber: Int
		}
	}

	struct ViewModel {
		let results: [SearchModel]

		struct SearchModel {
			let fileName: String
			let text: String
		}
	}
}
