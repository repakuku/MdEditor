//
//  MarkdownToPdfConverter.swift
//
//
//  Created by Alexey Turulin on 2/28/24.
//

import Foundation
import PDFKit

/// A MarkdownToPdfConverter class responsible for converting markdown text into a PDF document.
public final class MarkdownToPdfConverter: IMarkdownConverter {

	// MARK: - Dependencies

	private let visitor: AttributedTextVisitor
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
		visitor = AttributedTextVisitor()
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
		let lines = document.accept(visitor: visitor)

		let pdfMetaData = [
			kCGPDFContextAuthor: pdfAuthor,
			kCGPDFContextTitle: pdfTitle
		]

		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = pdfMetaData as [String: Any]

		let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageSize.pageRect, format: format)

		let data = graphicsRenderer.pdfData { context in
			newPage(context)

			var cursor = Const.cursorIndent

			lines.forEach { line in
				cursor = addAttributedText(
					context: context,
					text: line,
					indent: Const.textIndent,
					cursor: cursor,
					pdfSize: pageSize.pageRect.size
				)
			}
		}

		return data
	}
	 
	public func convert(markdownText: String, completion: @escaping (Data) -> Void) {
		let result = self.convert(markdownText: markdownText)
		completion(result)
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
			x: 2 * indent,
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
			newPage(context)
			return Const.cursorIndent
		}

		return cursor
	}

	 func newPage(_ context: UIGraphicsPDFRendererContext) {
		 context.beginPage()
		 context.cgContext.setFillColor(backgroundColor.cgColor)
		 context.fill(pageSize.pageRect)
	 }

	 enum Const {
		 static let cursorIndent: CGFloat = 20
		 static let textIndent: CGFloat = 20
		 static let safePageArea: CGFloat = 100
	 }
 }
