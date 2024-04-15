//
//  IMarkdownConverter.swift
//
//
//  Created by Alexey Turulin on 3/24/24.
//

import Foundation

/// Protocol for converting markdown text.
public protocol IMarkdownConverter {
	associatedtype ResultType

	func convert(markdownText: String, completion: @escaping (ResultType) -> Void)
}
