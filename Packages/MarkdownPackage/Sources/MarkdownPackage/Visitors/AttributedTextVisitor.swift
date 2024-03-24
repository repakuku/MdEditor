//
//  AttributedTextVisitor.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import UIKit

/// A visitor that translates markdown document elements into 'NSMutableAttributedString'
/// to support rich text formatting.
public final class AttributedTextVisitor: IVisitor {

	// MARK: - Dependencies

	private let appearance: IAppearance

	// MARK: - Private properties

	private let width: CGFloat

	// MARK: - Initialization

	/// Initializes a new AttributedTextVisitor instance.
	public init(appearance: IAppearance = Appearance(), width: CGFloat = .zero) {
		self.appearance = appearance
		self.width = width
	}

	// MARK: - Public methods

	/// Visits a document node and converts its children into an array of 'NSMutableAttributedString'.
	/// - Parameter node: The document node to visit.
	/// - Returns: An array of 'NSMutableAttributedString' representing the document content.
	public func visit(node: Document) -> [NSMutableAttributedString] {
		visitChildren(of: node)
	}

	/// Converts a header node into an attributed string.
	/// - Parameter node: The header node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the header.
	public func visit(node: HeaderNode) -> NSMutableAttributedString {
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(text)

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.headerColor(level: node.level),
			.font: UIFont.systemFont(ofSize: appearance.headerSize(level: node.level))
		]

		result.addAttributes(attributes, range: NSRange(0..<result.length))
		result.append(String.lineBreak)
		return result
	}

	/// Converts a paragraph node into an attributed string.
	/// - Parameter node: The paragraph node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the paragraph.
	public func visit(node: ParagraphNode) -> NSMutableAttributedString {
		let result = visitChildren(of: node).joined()
		result.append(String.lineBreak)
		return result
	}

	public func visit(node: TextNode) -> NSMutableAttributedString {
		return visitChildren(of: node).joined()
	}

	/// Converts a blockquote node into an attributed string.
	/// - Parameter node: The blockquote node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the blockquote.
	public func visit(node: BlockquoteNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let code = NSMutableAttributedString(
			string: String(repeating: ">", count: node.level) + " ",
			attributes: attributes
		)
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(String.lineBreak)

		return result
	}

	/// Converts a text node into an attributed string.
	/// - Parameter node: The text node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the text node's content.
	public func visit(node: PlainTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]
		let result = NSMutableAttributedString(string: node.text, attributes: attributes)
		return result
	}

	/// Converts a bold text node into an attributed string with bold formatting.
	/// - Parameter node: The bold text node to convert.
	/// - Returns: A bold formatted 'NSMutableAttributedString'.
	public func visit(node: BoldTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textBoldColor,
			.font: UIFont.boldSystemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(text)

		return result
	}

	/// Converts an italic text node into an attributed string with italic formatting.
	/// - Parameter node: The italic text node to convert.
	/// - Returns: An italic formatted 'NSMutableAttributedString'.
	public func visit(node: ItalicTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textItalicColor,
			.font: UIFont.boldSystemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(text)

		return result
	}

	/// Converts a bold and italic text node into an attributed string with both bold and italic formatting.
	/// - Parameter node: The bold and italic text node to convert.
	/// - Returns: A 'NSMutableAttributedString' with both bold and italic formatting..
	public func visit(node: BoldItalicTextNode) -> NSMutableAttributedString {
		let font: UIFont

		if let fontDescriptor = UIFontDescriptor
			.preferredFontDescriptor(withTextStyle: .body)
			.withSymbolicTraits([.traitBold, .traitItalic]) {
			font = UIFont(descriptor: fontDescriptor, size: appearance.textSize)
		} else {
			font = UIFont.boldSystemFont(ofSize: appearance.textSize)
		}

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textBoldItalicColor,
			.font: font
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		return text
	}

	public func visit(node: StrikeTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textStrikeColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize),
			.strikethroughStyle: NSUnderlineStyle.single.rawValue,
			.strikethroughColor: UIColor.red
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		return text
	}

	public func visit(node: HighlightedTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textHighlightedColor,
			.backgroundColor: appearance.highlightedTextBackgroundColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		return text
	}

	/// Handles an escaped character node.
	/// - Parameter node: The escaped character node.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the escaped char.
	public func visit(node: EscapedCharNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let result = NSMutableAttributedString(string: node.char, attributes: attributes)
		return result
	}

	/// Converts a code block node into an attributed string.
	/// - Parameter node: The code block node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the code block.
	public func visit(node: CodeBlockNode) -> NSMutableAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .right

		let langAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.codeLangColor,
			.font: UIFont.italicSystemFont(ofSize: appearance.codeLangSize),
			.paragraphStyle: paragraphStyle
		]

		let codeAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.codeTextColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.codeTextSize, weight: .medium)
		]

		let lang = NSMutableAttributedString(string: node.lang, attributes: langAttributes)
		let code = NSMutableAttributedString(string: node.code, attributes: codeAttributes)
		let result = NSMutableAttributedString()
		result.append(lang)
		result.append(String.lineBreak)
		result.append(code)
		result.append(String.lineBreak)
		return result
	}

	/// Converts an inline code node into an attributed string formatted as code.
	/// - Parameter node: The inline code node to convert.
	/// - Returns: An empty 'NSMutableAttributedString'.
	public func visit(node: InlineCodeNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.codeTextColor,
			.backgroundColor: appearance.codeBlockBackgroundColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.codeTextSize, weight: .medium)
		]

		let result = NSMutableAttributedString(string: node.code, attributes: attributes)
		return result
	}

	/// Handles a line break node by creating a newline in the attributed string.
	/// - Parameter node: The line break node.
	/// - Returns: A 'NSMutableAttributedString' containing a line break.
	public func visit(node: LineBreakNode) -> NSMutableAttributedString {
		String.lineBreak
	}

	/// Converts an image node into an attributed string.
	/// - Parameter node: The image node to convert.
	/// - Returns: A 'NSMutableAttributedString' including a reference to the image.
	public func visit(node: ImageNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		return result
	}

	/// Converts an ordered list node into an attributed string.
	/// - Parameter node: The ordered list node to convert.
	/// - Returns: A 'NSMutableAttributedString' containing an ordered list item.
	public func visit(node: OrderedListNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.textSize, weight: .medium)
		]

		let tab = NSMutableAttributedString(
			string: String(repeating: "\t", count: node.level),
			attributes: attributes
		)

		let items = visitChildren(of: node)

		let result = NSMutableAttributedString()
		var index = 0
		items.forEach {
			index += 1
			result.append(tab)
			result.append(NSMutableAttributedString(string: String("\(index). "), attributes: attributes))
			result.append($0)
			result.append(String.lineBreak)
		}

		return result
	}

	/// Converts an unordered list node into an attributed string.
	/// - Parameter node: The unordered list node to convert.
	/// - Returns: A 'NSMutableAttributedString' containing an unordered list item.
	public func visit(node: UnorderedListNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.textSize, weight: .medium)
		]

		let tab = NSMutableAttributedString(
			string: String(repeating: "\t", count: node.level),
			attributes: attributes
		)

		let items = visitChildren(of: node)

		let result = NSMutableAttributedString()
		items.forEach {
			result.append(tab)
			result.append(NSMutableAttributedString(string: String("• "), attributes: attributes))
			result.append($0)
			result.append(String.lineBreak)
		}

		return result
	}

	/// Handles a line node by creating a line in the attributed string.
	/// - Parameter node: The line node.
	/// - Returns: A 'NSMutableAttributedString' containing a line.
	public func visit(node: LineNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]
		let fontWidth = ("_" as NSString).size(withAttributes: attributes).width
		let result = NSMutableAttributedString(
			string: String(repeating: "_", count: Int(width / fontWidth)),
			attributes: attributes
		)
		result.append(String.lineBreak)

		return result
	}

	public func visit(node: ExternalLinkNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.link: node.url,
			.font: UIFont.systemFont(ofSize: appearance.textSize),
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let result = NSMutableAttributedString(string: node.text, attributes: attributes)
		return result
	}

	public func visit(node: InternalLinkNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.link: node.url,
			.font: UIFont.systemFont(ofSize: appearance.textSize),
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let result = NSMutableAttributedString(string: node.url, attributes: attributes)
		return result
	}
}
