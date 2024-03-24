//
//  Document+CustomStringConvertible.swift
//
//
//  Created by Alexey Turulin on 2/25/24.
//

import Foundation

extension Document: CustomStringConvertible {
	public var description: String {
		"\(children.map { "\($0)" }.joined())"
	}
}

extension HeaderNode: CustomStringConvertible {
	public var description: String {
		"Header Level \(level):\n \(children.map { "\t\($0)" }.joined())\n"
	}
}

extension BlockquoteNode: CustomStringConvertible {
	public var description: String {
		"Blockquote Level \(level):\n \(children.map { "\t\($0)" }.joined())\n"
	}
}

extension ParagraphNode: CustomStringConvertible {
	public var description: String {
		"Paragraph: \n\(children.map { "\t\($0)" }.joined())\n"
	}
}

extension PlainTextNode: CustomStringConvertible {
	public var description: String {
		"PlainTextNode: \(text)\n"
	}
}

extension BoldTextNode: CustomStringConvertible {
	public var description: String {
		"BoldTextNode: \(text)\n"
	}
}

extension BoldItalicTextNode: CustomStringConvertible {
	public var description: String {
		"BoldItalicTextNode: \(text)\n"
	}
}

extension ItalicTextNode: CustomStringConvertible {
	public var description: String {
		"ItalicTextNode: \(text)\n"
	}
}

extension EscapedCharNode: CustomStringConvertible {
	public var description: String {
		"EscapedCharNode: \(char)\n"
	}
}

extension InlineCodeNode: CustomStringConvertible {
	public var description: String {
		"InlineCodeNode: \(code)\n"
	}
}

extension LineBreakNode: CustomStringConvertible {
	public var description: String {
		"LineBreakNode \n"
	}
}

extension TaskNode: CustomStringConvertible {
	public var description: String {
		"TaskNode (\(isDone ? "completed" : "uncompleted")): \n\(children.map { "\t\($0)" }.joined())\n"
	}
}
