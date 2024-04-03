//
//  Token.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/27/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct Token {
	let rawValue: String
}

extension Token: CustomStringConvertible, CustomDebugStringConvertible {
	var description: String {
		"********"
	}

	var debugDescription: String {
		"********"
	}
}
