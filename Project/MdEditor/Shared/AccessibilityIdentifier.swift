//
//  AccessibilityIdentifier.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

enum AccessibilityIdentifier {
	case textFieldLogin
	case textFieldPass
	case buttonLogin

	case section(index: Int)
	case cell(section: Int, index: Int)

	var description: String {
		switch self {
		case .textFieldLogin:
			"textFieldLogin"
		case .textFieldPass:
			"textFieldPass"
		case .buttonLogin:
			"buttonLogin"
		case .section(index: let index):
			"section-\(index)"
		case .cell(section: let section, index: let index):
			"cell-\(section)-\(index)"
		}
	}
}
