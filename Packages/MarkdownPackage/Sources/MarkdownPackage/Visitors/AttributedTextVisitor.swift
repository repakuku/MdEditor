//
//  AttributedTextVisitor.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import UIKit

/// Protocol defining the color scheme for attributed text rendering.
public protocol IAttributedTextColors {

	/// The primary color.
	var mainColor: UIColor { get }

	/// An accent color.
	var accentColor: UIColor { get }
}

/// Protocol for managing font styles.
public protocol IFonts {

	/// The font used for normal text.
	var normalText: UIFont { get }

	/// The font used for bold text.
	var boldText: UIFont { get }

	/// The font used for italic text.
	var italicText: UIFont { get }

	/// The font used for bold and italic text.
	var boldAndItalicText: UIFont { get }

	/// The font used for code text.
	var codeText: UIFont { get }

	/// The font used specifically for displaying code language.
	var codeBlock: UIFont { get }

	/// Returns the font for headers at different levels.
	/// - Parameter level: An integer representing the level of the header 
	/// (1 for H1, 2 for H2, 3 for H3, 4 for H4, 5 for H5, 6 for H6).
	/// - Returns: The font used for header.
	func getHeaderFont(level: Int) -> UIFont
}

/// A visitor that translates markdown document elements into 'NSMutableAttributedString'
/// to support rich text formatting.
public final class AttributedTextVisitor: IVisitor {

	// MARK: - Dependencies

	private let theme: IAttributedTextColors
	private let fonts: IFonts

	// MARK: - Initialization

	/// Initializes a new AttributedTextVisitor instance.
	public init(theme: IAttributedTextColors, fonts: IFonts) {
		self.theme = theme
		self.fonts = fonts
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
		result.append(String.lineBreak)

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.getHeaderFont(level: node.level - 1)
		]

		result.addAttributes(attributes, range: NSRange(0..<result.length))

		return result
	}

	/// Converts a paragraph node into an attributed string.
	/// - Parameter node: The paragraph node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the paragraph.
	public func visit(node: ParagraphNode) -> NSMutableAttributedString {
		let result = visitChildren(of: node).joined()
		result.append(String.lineBreak)

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.firstLineHeadIndent = Appearance.textHeadIndent
		result.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(0..<result.length))

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

	/// Converts a text node into an attributed string.
	/// - Parameter node: The text node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the text node's content.
	public func visit(node: TextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.normalText
		]
		let result = NSMutableAttributedString(string: node.text, attributes: attributes)
		return result
	}

	/// Converts a bold text node into an attributed string with bold formatting.
	/// - Parameter node: The bold text node to convert.
	/// - Returns: A bold formatted 'NSMutableAttributedString'.
	public func visit(node: BoldTextNode) -> NSMutableAttributedString {

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.boldText
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
			.foregroundColor: theme.mainColor,
			.font: fonts.italicText
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
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.boldAndItalicText
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(text)

		return result
	}

	/// Handles an escaped character node.
	/// - Parameter node: The escaped character node.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the escaped char.
	public func visit(node: EscapedCharNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		return result
	}

	/// Converts a code block node into an attributed string.
	/// - Parameter node: The code block node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the code block.
	public func visit(node: CodeBlockNode) -> NSMutableAttributedString {

		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .right

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.accentColor,
			.font: fonts.codeBlock,
			.paragraphStyle: paragraphStyle
		]

		let lang = NSMutableAttributedString(string: node.lang ?? "", attributes: attributes)
		let result = NSMutableAttributedString()
		result.append(lang)
		result.append(String.lineBreak)
		return result
	}

	/// Converts a code line node into an attributed string.
	/// - Parameter node: The code line node to convert.
	/// - Returns: A formatted 'NSMutableAttributedString' representing the code line.
	public func visit(node: CodeLineNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.codeText
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(String.tab)
		result.append(text)
		result.append(String.lineBreak)

		return result
	}

	/// Converts an inline code node into an attributed string formatted as code.
	/// - Parameter node: The inline code node to convert.
	/// - Returns: An empty 'NSMutableAttributedString'.
	public func visit(node: InlineCodeNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.codeText
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
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.mainColor,
			.font: fonts.normalText
		]

		let result = NSMutableAttributedString(string: node.url, attributes: attributes)
		result.append(String.lineBreak)

		return result
	}

	/// Converts an ordered list node into an attributed string.
	/// - Parameter node: The ordered list node to convert.
	/// - Returns: A 'NSMutableAttributedString' containing an ordered list item.
	public func visit(node: OrderedListNode) -> NSMutableAttributedString {
		let tab = makeMarkdownCode(String(repeating: String.tab.string, count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(tab)
		result.append(text)
		result.append(String.lineBreak)

		return result
	}

	/// Converts an unordered list node into an attributed string.
	/// - Parameter node: The unordered list node to convert.
	/// - Returns: A 'NSMutableAttributedString' containing an unordered list item.
	public func visit(node: UnorderedListNode) -> NSMutableAttributedString {
		let tab = makeMarkdownCode(String(repeating: String.tab.string, count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(tab)
		result.append(text)
		result.append(String.lineBreak)

		return result
	}

	/// Handles a line node by creating a line in the attributed string.
	/// - Parameter node: The line node.
	/// - Returns: A 'NSMutableAttributedString' containing a line.
	public func visit(node: LineNode) -> NSMutableAttributedString {
		let screenSize: CGRect = UIScreen.main.bounds
		let result = NSMutableAttributedString(string: String(repeating: "_", count: Int(screenSize.width) / 8))
		result.append(String.lineBreak)

		return result
	}

	/// Handles a link node by creating a link in the attributed string.
	/// - Parameter node: The link node.
	/// - Returns: A 'NSMutableAttributedString' containing a link.
	public func visit(node: LinkNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.link: NSURL(string: node.url) as Any,
			.font: fonts.normalText
		]

		let result = NSMutableAttributedString(string: node.title ?? node.url, attributes: attributes)
		result.append(String.lineBreak)
		return result
	}
}

private extension AttributedTextVisitor {
	func makeMarkdownCode(_ code: String) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: theme.accentColor
		]

		return NSMutableAttributedString(string: code, attributes: attributes)
	}
}

// MARK: - Appearance

private extension AttributedTextVisitor {
	enum Appearance {
		static let textHeadIndent: CGFloat = 18
	}
}
