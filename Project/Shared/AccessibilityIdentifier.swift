//
//  AccessibilityIdentifier.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/16/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

// TODO: Add documentation
enum AccessibilityIdentifier {

	enum LoginScene: CustomStringConvertible {
		case textFieldLogin
		case textFieldPass
		case buttonLogin

		var description: String {
			switch self {
			case .textFieldLogin:
				return "loginScene.textFieldLogin"
			case .textFieldPass:
				return "loginScene.textFieldPass"
			case .buttonLogin:
				return "loginScene.buttonLogin"
			}
		}
	}

	enum TodoListScene: CustomStringConvertible {
		case table
		case section(Int)
		case cell(section: Int, row: Int)

		var description: String {
			switch self {
			case .table:
				"todoListScene.table"
			case .section(let index):
				"todoListScene.section-\(index)"
			case .cell(section: let section, row: let row):
				"todoListScene.cell-\(section)-\(row)"
			}
		}
	}
}
