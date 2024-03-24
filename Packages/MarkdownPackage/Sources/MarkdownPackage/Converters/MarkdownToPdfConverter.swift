//
//  MarkdownToPdfConverter.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation
import PDFKit

///// Protocol for converting markdown text into a PDF document.
// public protocol IMarkdownToPdfConverter {
//
//	/// Converts markdown text into a PDF document.
//	/// - Parameters:
//	///   - markdownText: A string containing markdown formatted text.
//	///   - completion:Handler to return the PDF as 'Data'
//	func convert(
//		markdownText: String,
//		completion: @escaping (Data) -> Void
//	)
// }
//
///// A MarkdownToPdfConverter class responsible for converting markdown text into a PDF document.
// public final class MarkdownToPdfConverter: IMarkdownToPdfConverter {
//
//	private struct Cursor {
//		static let initialPosition: CGFloat = 40
//		static let indent: CGFloat = 12
//
//		var position: CGFloat = Cursor.initialPosition
//	}
//
//	// MARK: - Dependencies
//
//	private let visitor: AttributedTextVisitor
//	private let markdownToDocument = MarkdownToDocument()
//
//	// MARK: - Private properties
//
//	private let pageSize: PageSize
//	private let backgroundColor: UIColor
//	private let pdfAuthor: String
//	private let pdfTitle: String
//
//	// MARK: - Initialization
//
//	/// Initializes a MarkdownToPdfConverter instance.
//	public init(pageSize: PageSize, backgroundColor: UIColor, pdfAuthor: String, pdfTitle: String) {
//		self.pageSize = pageSize
//		self.backgroundColor = backgroundColor
//		self.pdfAuthor = pdfAuthor
//		self.pdfTitle = pdfTitle
//		visitor = AttributedTextVisitor()
//	}
//
//	// MARK: - Public Methods
//
//	/// Converts markdown text into a PDF document.
//	/// - Parameters:
//	///   - markdownText: A string containing markdown formatted text.
//	///   - author: Author of the document.
//	///   - title: Title of the document
//	///   - pageFormat: Format of the PDF pages.
//	///   - completion:Handler to return the PDF as 'Data'
//	public func convert(markdownText: String, completion: @escaping (Data) -> Void) {
//		let document = markdownToDocument.convert(markdownText: markdownText)
//		let format = UIGraphicsPDFRendererFormat()
//
//		let pdfMetaData = [
//			kCGPDFContextAuthor: pdfAuthor,
//			kCGPDFContextTitle: pdfTitle
//		]
//
//		format.documentInfo = pdfMetaData as [String: Any]
//
//		let pageRect = pageSize.pageRect
//
//		let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
//
//		let lines = document.accept(visitor: visitor)
//
//		let data = graphicsRenderer.pdfData { context in
//			context.beginPage()
//			context.cgContext.setFillColor(backgroundColor.cgColor)
//			context.fill(pageRect)
//
//			var cursor = Cursor()
//
//			lines.forEach { line in
//				cursor.position = self.addAttributedText(
//					context: context,
//					text: line,
//					indent: Cursor.indent,
//					cursor: cursor.position,
//					pdfSize: pageRect.size
//				)
//
//				cursor.position += Cursor.indent
//			}
//		}
//
//		completion(data)
//	}
//	
//	public enum PageSize {
//		// swiftlint:disable identifier_name
//		case a4
//
//		case screen
//
//		var pageRect: CGRect {
//			switch self {
//			case .a4:
//				return CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
//			case .screen:
//				return UIScreen.main.bounds
//			}
//		}
//	}
// }
//
// private extension MarkdownToPdfConverter {
//	func addAttributedText(
//		context: UIGraphicsPDFRendererContext,
//		text: NSAttributedString,
//		indent: CGFloat,
//		cursor: CGFloat,
//		pdfSize: CGSize
//	) -> CGFloat {
//		let pdfTextHeight = textHeight(text, withConstrainedWidth: pdfSize.width - 2 * indent)
//
//		let rect = CGRect(
//			x: 2 * indent,
//			y: cursor,
//			width: pdfSize.width - 2 * indent,
//			height: pdfTextHeight
//		)
//
//		text.draw(in: rect)
//
//		return checkContext(
//			context: context,
//			cursor: rect.origin.y + rect.size.height,
//			pdfSize: pdfSize
//		)
//	}
//
//	func textHeight(_ text: NSAttributedString, withConstrainedWidth width: CGFloat) -> CGFloat {
//		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//		let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
//
//		return ceil(boundingBox.height)
//	}
//
//	func checkContext(
//		context: UIGraphicsPDFRendererContext,
//		cursor: CGFloat,
//		pdfSize: CGSize
//	) -> CGFloat {
//		if cursor > pdfSize.height - 100 {
//			context.beginPage()
//			return Cursor.initialPosition
//		}
//
//		return cursor
//	}
// }

/// A MarkdownToPdfConverter class responsible for converting markdown text into a PDF document.
public final class MarkdownToPdfConverter: IMarkdownConverter {

	// MARK: - Dependencies

	private let visitor = AttributedTextVisitor()
	private let markdownToDocument = MarkdownToDocument()

	// MARK: - Private properties

	private let pageSize: PageSize
	private let backgroundColor: UIColor
	private let pdfAuthor: String
	private let pdfTitle: String

	// MARK: - Initialization

	/// Initializes a MarkdownToPdfConverter instance.
	public init(pageSize: PageSize, backgroundColor: UIColor, pdfAuthor: String, pdfTitle: String) {
		self.pageSize = pageSize
		self.backgroundColor = backgroundColor
		self.pdfAuthor = pdfAuthor
		self.pdfTitle = pdfTitle
	}

	// MARK: - Public Methods

	/// Converts markdown text into a PDF document.
	/// - Parameters:
	///   - markdownText: A string containing markdown formatted text.
	///   - author: Author of the document.
	///   - title: Title of the document
	///   - pageFormat: Format of the PDF pages.
	///   - completion:Handler to return the PDF as 'Data'
	public func convert(markdownText: String) -> Data {
		let document = markdownToDocument.convert(markdownText: markdownText)
		let format = UIGraphicsPDFRendererFormat()

		let pdfMetaData = [
			kCGPDFContextAuthor: pdfAuthor,
			kCGPDFContextTitle: pdfTitle
		]

		format.documentInfo = pdfMetaData as [String: Any]

		let pageRect = pageSize.pageRect

		let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

		let lines = document.accept(visitor: visitor)

		let data = graphicsRenderer.pdfData { context in
			newPage(context)

			var cursor = Const.cursorIndent

			lines.forEach { line in
				cursor = self.addAttributedText(
					context: context,
					text: line,
					indent: Const.textIndent,
					cursor: cursor,
					pdfSize: pageRect.size
				)
			}
		}

		return data
	}

	public enum PageSize {
		// swiftlint:disable identifier_name
		case a4

		case screen

		var pageRect: CGRect {
			switch self {
			case .a4:
				return CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
			case .screen:
				return UIScreen.main.bounds
			}
		}
	}
}

private extension MarkdownToPdfConverter {
	func addAttributedText(
		context: UIGraphicsPDFRendererContext,
		text: NSAttributedString,
		indent: CGFloat,
		cursor: CGFloat,
		pdfSize: CGSize
	) -> CGFloat {
		let pdfTextHeight = textHeight(text, withConstrainedWidth: pdfSize.width - 2 * indent)

		let rect = CGRect(
			x: indent,
			y: cursor,
			width: pdfSize.width - 2 * indent,
			height: pdfTextHeight
		)

		text.draw(in: rect)

		return checkContext(
			context: context,
			cursor: rect.origin.y + rect.size.height,
			pdfSize: pdfSize
		)
	}

	func textHeight(_ text: NSAttributedString, withConstrainedWidth width: CGFloat) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

		return ceil(boundingBox.height)
	}

	func checkContext(
		context: UIGraphicsPDFRendererContext,
		cursor: CGFloat,
		pdfSize: CGSize
	) -> CGFloat {
		if cursor > pdfSize.height - Const.safePageArea {
			context.beginPage()
			return Const.cursorIndent
		}

		return cursor
	}

	func newPage(_ context: UIGraphicsPDFRendererContext) {
		context.beginPage()
		context.cgContext.setFillColor(backgroundColor.cgColor)
		context.fill(pageSize.pageRect)
	}

	private struct Const {
		static let cursorIndent: CGFloat = 20
		static let textIndent: CGFloat = 20
		static let safePageArea: CGFloat = 100
	}
}
