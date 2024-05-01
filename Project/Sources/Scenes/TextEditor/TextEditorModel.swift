//
//  TextEditorModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum TextEditorModel {

	enum Response {
		case initial(fileUrl: URL, fileContent: String, searchText: String?)
		case convert(text: String)
		case print(text: String)
	}

	enum ViewModel {
		case initial(text: String, title: String, hasTasks: Bool, searchText: String?)
		case convert(text: NSMutableAttributedString, hasTasks: Bool)
		case print(data: Data)
	}
}
