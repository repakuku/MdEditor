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
		case resultSelected(indexPath: IndexPath)
	}

	struct Response {
		let result: [String]
	}

	struct ViewModel {
		let result: [String]
	}
}
