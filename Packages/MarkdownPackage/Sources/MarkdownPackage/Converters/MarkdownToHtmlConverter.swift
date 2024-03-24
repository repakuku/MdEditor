//
//  MarkdownToHtmlConverter.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation

/// A MarkdownToHtmlConverter class responsible for converting markdown text into an HTML string.
public final class MarkdownToHtmlConverter: IMarkdownConverter {

	// MARK: - Private properties

	private let visitor = HtmlVisitor()
	private let markdownToDocumnet = MarkdownToDocument()

	// MARK: - Initializers

	/// Initializes a IMarkdownToHtmlConverter instance.
	public init() { }

	// MARK: - Public methods

	/// Converts markdown text into HTML string.
	/// - Parameter markdownText: A string containing markdown formatted text.
	/// - Returns: A string formatted as HTML.
	public func convert(markdownText: String) -> String {
		let documnet = markdownToDocumnet.convert(markdownText: markdownText)
		let html = documnet.accept(visitor: visitor)

		return makeHtml(html.joined())
	}

	// MARK: - Private methods

	private func makeHtml(_ text: String) -> String {
		"<!DOCTYPE html><html><head><style> body {font-size: 350%;} </style></head><body>\(text)<body></html>"
	}
}
