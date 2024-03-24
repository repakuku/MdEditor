//
//  IMarkdownConverter.swift
//
//
//  Created by Alexey Turulin on 3/24/24.
//

import Foundation

/// Protocol for converting markdown text.
public protocol IMarkdownConverter {
	associatedtype Result

	/// Converts markdown text'.
	/// - Parameter markdownText: A string containing markdown formatted text.
	/// - Returns: The formatted text.
	func convert(markdownText: String) -> Result
}
