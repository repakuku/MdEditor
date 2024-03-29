//
//  PathComponent.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

enum PathComponent {
	case login
	case files
	case upload

	var path: String {
		switch self {
		case .login:
			return "/api/auth/login"
		case .files:
			return "/api/files"
		case .upload:
			return "/api/files/upload"
		}
	}
}
