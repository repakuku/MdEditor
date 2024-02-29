//
//  IVisitor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

public protocol IVisitor {
	associatedtype Result

	func visit(node: Document) -> [Result]
	func visit(node: HeaderNode) -> Result
	func visit(node: ParagraphNode) -> Result
	func visit(node: BlockquoteNode) -> Result
	func visit(node: TextNode) -> Result
	func visit(node: BoldTextNode) -> Result
	func visit(node: ItalicTextNode) -> Result
	func visit(node: BoldItalicTextNode) -> Result
	func visit(node: EscapedCharNode) -> Result
	func visit(node: InlineCodeNode) -> Result
	func visit(node: LineBreakNode) -> Result
	func visit(node: ImageNode) -> Result
}

extension IVisitor {
	func visitChildren(of node: INode) -> [Result] {
		return node.children.compactMap { child in
			switch child {
			case let child as HeaderNode:
				return visit(node: child)
			case let child as ParagraphNode:
				return visit(node: child)
			case let child as BlockquoteNode:
				return visit(node: child)
			case let child as TextNode:
				return visit(node: child)
			case let child as BoldTextNode:
				return visit(node: child)
			case let child as ItalicTextNode:
				return visit(node: child)
			case let child as BoldItalicTextNode:
				return visit(node: child)
			case let child as InlineCodeNode:
				return visit(node: child)
			case let child as LineBreakNode:
				return visit(node: child)
			case let child as ImageNode:
				return visit(node: child)
			default:
				return nil
			}
		}
	}
}
