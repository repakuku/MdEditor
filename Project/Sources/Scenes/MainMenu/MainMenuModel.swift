//
//  MainMenuModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum MainMenuModel {
	struct Response {
		var files: [File]
	}

	struct ViewModel {
		let recentFiles: [File]

		struct File {
			let name: String
		}
	}
}
