//
//  MainQueueDispatchDecorator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/8/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownPackage

/// A decorator for 'IMarkdownToPdfConverter'.
final class MainQueueDispatchConverterDecorator<Converter: IMarkdownConverter>: IMarkdownConverter {
	typealias ResultType = Converter.ResultType

	// MARK: - Dependencies

	private let decoratee: Converter

	// MARK: - Initialization

	/// Initializes a new instance with the given markdown to PDF converter.
	/// - Parameter decoratee: The actual converter.
	init(decoratee: Converter) {
		self.decoratee = decoratee
	}

	// MARK: - Public Methods

	/// Converts markdown text into a PDF document, ensuring that the conversion process is executed
	/// on a background thread and the completion handler is called on the main thread.
	/// - Parameters:
	///   - markdownText: The markdown formatted text to convert.
	///   - completion: A completion handler that is called with the result.
	func convert(markdownText: String, completion: @escaping (ResultType) -> Void) {
		decoratee.convert(markdownText: markdownText) { [weak self] result in
			self?.doInMainThread {
				completion(result)
			}
		}
	}

	// MARK: - Private Methods

	private func doInMainThread(_ work: @escaping () -> Void) {
		if Thread.isMainThread {
			work()
		} else {
			DispatchQueue.main.async(execute: work)
		}
	}
}
