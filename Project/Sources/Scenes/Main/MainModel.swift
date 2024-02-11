//
//  MainModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum MainModel {
	struct Response {
		var files: [File]
	}

	struct ViewModel {
		let recentFiles: [RecentFile]

		struct RecentFile {
			let name: String
		}
	}
}
