//
//  RawAttributedTextVisitor.swift
//
//
//  Created by Alexey Turulin on 3/23/24.
//

import UIKit

/// A visitor that translates markdown document elements into 'NSMutableAttributedString'
/// to support rich text formatting.
public final class RawAttributedTextVisitor: IVisitor {

	// MARK: - Dependencies

	private let appearance: IAppearance

	// MARK: - Initialization

	/// Initializes a new AttributedTextVisitor instance.
	public init(appearance: IAppearance = Appearance()) {
		self.appearance = appearance
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
		let code = makeMarkdownCode(String(repeating: "#", count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let textAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.headerColor(level: node.level),
			.font: UIFont.systemFont(ofSize: appearance.headerSize(level: node.level))
		]

		let codeAttributes: [NSAttributedString.Key: Any] = [
			.font: UIFont.systemFont(ofSize: appearance.headerSize(level: node.level))
		]

		text.addAttributes(textAttributes, range: NSRange(0..<text.length))
		code.addAttributes(codeAttributes, range: NSRange(0..<code.length))

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
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

	/// Converts a blockquote node into an attributed string.
	/// - Parameter node: The blockquote node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the blockquote.
	public func visit(node: BlockquoteNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode(String(repeating: ">", count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(String.lineBreak)

		return result
	}

	public func visit(node: TextNode) -> NSMutableAttributedString {
		return visitChildren(of: node).joined()
	}

	/// Converts a text node into an attributed string.
	/// - Parameter node: The text node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the text node's content.
	public func visit(node: PlainTextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)
		return text
	}

	/// Converts a bold text node into an attributed string with bold formatting.
	/// - Parameter node: The bold text node to convert.
	/// - Returns: A bold formatted 'NSMutableAttributedString'.
	public func visit(node: BoldTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("**")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textBoldColor,
			.font: UIFont.boldSystemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	/// Converts an italic text node into an attributed string with italic formatting.
	/// - Parameter node: The italic text node to convert.
	/// - Returns: An italic formatted 'NSMutableAttributedString'.
	public func visit(node: ItalicTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("*")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textItalicColor,
			.font: UIFont.boldSystemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	/// Converts a bold and italic text node into an attributed string with both bold and italic formatting.
	/// - Parameter node: The bold and italic text node to convert.
	/// - Returns: A 'NSMutableAttributedString' with both bold and italic formatting..
	public func visit(node: BoldItalicTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("***")

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

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	public func visit(node: StrikeTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("~~")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textStrikeColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize),
			.strikethroughStyle: NSUnderlineStyle.single.rawValue,
			.strikethroughColor: UIColor.red
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	public func visit(node: HighlightedTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("==")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textHighlightedColor,
			.backgroundColor: appearance.highlightedTextBackgroundColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	/// Handles an escaped character node.
	/// - Parameter node: The escaped character node.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the escaped char.
	public func visit(node: EscapedCharNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.textColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		let result = makeMarkdownCode("\\")
		result.append(NSMutableAttributedString(string: node.char, attributes: attributes))

		return result
	}

	/// Converts a code block node into an attributed string.
	/// - Parameter node: The code block node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the code block.
	public func visit(node: CodeBlockNode) -> NSMutableAttributedString {
		let result = makeMarkdownCode(String(repeating: "`", count: node.level) + node.lang)

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.codeTextColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.codeTextSize, weight: .medium)
		]

		let text = NSMutableAttributedString(string: node.code, attributes: attributes)
		result.append(String.lineBreak)
		result.append(text)
		result.append(String.lineBreak)
		result.append(makeMarkdownCode(String(repeating: "`", count: node.level)))
		result.append(String.lineBreak)

		return result
	}

	/// Converts an inline code node into an attributed string formatted as code.
	/// - Parameter node: The inline code node to convert.
	/// - Returns: An empty 'NSMutableAttributedString'.
	public func visit(node: InlineCodeNode) -> NSMutableAttributedString {
		let result = makeMarkdownCode("`")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.codeTextColor,
			.backgroundColor: appearance.codeBlockBackgroundColor,
			.font: UIFont.monospacedDigitSystemFont(ofSize: appearance.codeTextSize, weight: .medium)
		]

		let text = NSMutableAttributedString(string: node.code, attributes: attributes)
		result.append(text)
		result.append(makeMarkdownCode("`"))

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
			result.append(makeMarkdownCode("\(index). "))
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
			result.append(makeMarkdownCode("- "))
			result.append($0)
			result.append(String.lineBreak)
		}

		return result
	}

	/// Handles a line node by creating a line in the attributed string.
	/// - Parameter node: The line node.
	/// - Returns: A 'NSMutableAttributedString' containing a line.
	public func visit(node: LineNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		result.append(makeMarkdownCode("---"))
		result.append(String.lineBreak)
		return result
	}

	public func visit(node: ExternalLinkNode) -> NSMutableAttributedString {
		let result = makeMarkdownCode("[")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.linkColor,
			.font: UIFont.italicSystemFont(ofSize: appearance.textSize),
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)
		let url = NSMutableAttributedString(string: node.url, attributes: attributes)

		result.append(text)
		result.append(makeMarkdownCode("]("))
		result.append(url)
		result.append(makeMarkdownCode(")"))
		return result
	}

	public func visit(node: InternalLinkNode) -> NSMutableAttributedString {
		let result = makeMarkdownCode("[[")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.linkColor,
			.font: UIFont.italicSystemFont(ofSize: appearance.textSize),
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		let url = NSMutableAttributedString(string: node.url, attributes: attributes)

		result.append(url)
		result.append(makeMarkdownCode("]]"))
		return result
	}
}

private extension RawAttributedTextVisitor {
	func makeMarkdownCode(_ code: String) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: appearance.markdownCodeColor,
			.font: UIFont.systemFont(ofSize: appearance.textSize)
		]

		return NSMutableAttributedString(string: code, attributes: attributes)
	}
}
