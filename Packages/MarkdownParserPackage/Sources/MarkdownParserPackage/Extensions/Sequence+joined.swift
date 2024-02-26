//
//  Sequence+joined.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import Foundation

public extension Sequence where Iterator.Element == NSMutableAttributedString {
	func joined() -> NSMutableAttributedString {
		reduce(into: NSMutableAttributedString()) { $0.append($1) }
	}
}
