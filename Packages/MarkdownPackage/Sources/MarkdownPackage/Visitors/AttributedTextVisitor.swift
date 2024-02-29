//
//  AttributedTextVisitor.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import UIKit

#warning("TODO: Fix hard code")
public final class AttributedTextVisitor: IVisitor {

	public init() { }

	public func visit(node: Document) -> [NSMutableAttributedString] {
		visitChildren(of: node)
	}

	public func visit(node: HeaderNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode(String(repeating: "#", count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(String.lineBreak)
		result.append(String.lineBreak)

		let sizes: [CGFloat] = [32, 28, 26, 24, 22, 20]

		result.addAttribute(.font, value: UIFont.systemFont(ofSize: sizes[node.level - 1]), range: NSRange(0..<result.length))

		return result
	}

	public func visit(node: ParagraphNode) -> NSMutableAttributedString {
		let result = visitChildren(of: node).joined()
		result.append(String.lineBreak)
		result.append(String.lineBreak)
		return result
	}

	public func visit(node: BlockquoteNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode(String(repeating: ">", count: node.level) + " ")
		let text = visitChildren(of: node).joined()

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(String.lineBreak)
		result.append(String.lineBreak)

		return result
	}

	public func visit(node: TextNode) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.black,
			.font: UIFont.systemFont(ofSize: 18)
		]
		let result = NSMutableAttributedString(string: node.text, attributes: attributes)
		return result
	}

	public func visit(node: BoldTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("**")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.font: UIFont.boldSystemFont(ofSize: 18)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	public func visit(node: ItalicTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("*")

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.font: UIFont.italicSystemFont(ofSize: 18)
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	public func visit(node: BoldItalicTextNode) -> NSMutableAttributedString {
		let code = makeMarkdownCode("***")

		let font: UIFont

		if let fontDescriptor = UIFontDescriptor
			.preferredFontDescriptor(withTextStyle: .body)
			.withSymbolicTraits([.traitBold, .traitItalic]) {
			font = UIFont(descriptor: fontDescriptor, size: 18)
		} else {
			font = UIFont.boldSystemFont(ofSize: 18)
		}

		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.font: font
		]

		let text = NSMutableAttributedString(string: node.text, attributes: attributes)

		let result = NSMutableAttributedString()
		result.append(code)
		result.append(text)
		result.append(code)

		return result
	}

	public func visit(node: EscapedCharNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		return result
	}

	public func visit(node: InlineCodeNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		return result
	}

	public func visit(node: LineBreakNode) -> NSMutableAttributedString {
		String.lineBreak
	}

	public func visit(node: ImageNode) -> NSMutableAttributedString {
		let result = NSMutableAttributedString()
		return result
	}
}

private extension AttributedTextVisitor {
	func makeMarkdownCode(_ code: String) -> NSMutableAttributedString {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.lightGray
		]

		return NSMutableAttributedString(string: code, attributes: attributes)
	}
}
