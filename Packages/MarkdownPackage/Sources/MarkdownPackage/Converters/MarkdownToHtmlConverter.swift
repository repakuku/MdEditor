//
//  MarkdownToHtmlConverter.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation

public protocol IMarkdownToHtmlConverter {
	func convert(markdownText: String) -> String
}

public final class MarkdownToHtmlConverter: IMarkdownToHtmlConverter {

	// MARK: - Private properties

	private let visitor = HtmlVisitor()
	private let markdownToDocumnet = MarkdownToDocument()

	// MARK: - Initializers

	public init() { }

	// MARK: - Public methods

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
