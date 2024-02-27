//
//  MarkdownToAttributedStringConverter.swift
//
//
//  Created by Alexey Turulin on 2/26/24.
//

import UIKit

public protocol IMarkdownToAttributedStringConverter {
	func convertToAttributedText(rawText: String) -> NSMutableAttributedString
}

public final class MarkdownToAttributedStringConverter: IMarkdownToAttributedStringConverter {
	
	// MARK: - Dependencies
	
	private let mainColor: UIColor
	private let accentColor: UIColor
	
	private let lexer = Lexer()
	private let parser = Parser()
	private let visitor: AttributedTextVisitor
	
	// MARK: - initialization
	
	public init(
		mainColor: UIColor,
		accentColor: UIColor
	) {
		self.mainColor = mainColor
		self.accentColor = accentColor
		
		visitor = AttributedTextVisitor(mainColor: mainColor, accentColor: accentColor)
	}
	
	// MARK: - Public methods
	
	public func convertToAttributedText(rawText: String) -> NSMutableAttributedString {
		let tokens = lexer.tokenize(rawText)
		let document = parser.parse(tokens: tokens)
		let attributedText = document.accept(visitor: visitor).joined()
		return attributedText
	}
}
