//
//  File.swift
//  
//
//  Created by Alexey Turulin on 3/23/24.
//

import UIKit

public protocol IAppearance {
	var markdownCodeColor: UIColor { get }

	var textSize: CGFloat { get }
	var textColor: UIColor { get }

	var linkColor: UIColor { get }
	var textBoldColor: UIColor { get }
	var textItalicColor: UIColor { get }
	var textBoldItalicColor: UIColor { get }
	var textStrikeColor: UIColor { get }
	var textHighlightedColor: UIColor { get }
	var highlightedTextBackgroundColor: UIColor { get }

	var codeTextSize: CGFloat { get }
	var codeLangSize: CGFloat { get }
	var codeBlockBackgroundColor: UIColor { get }
	var codeLangColor: UIColor { get }
	var codeTextColor: UIColor { get }

	func headerSize(level: Int) -> CGFloat
	func headerColor(level: Int) -> UIColor
}

public extension IAppearance {

	var markdownCodeColor: UIColor {
		.systemBrown
	}

	var textSize: CGFloat {
		18
	}

	var textColor: UIColor {
		darkColor
	}

	var linkColor: UIColor {
		.systemBlue
	}

	var textBoldColor: UIColor {
		darkColor
	}
	var textItalicColor: UIColor {
		darkColor
	}

	var textBoldItalicColor: UIColor {
		darkColor
	}

	var textStrikeColor: UIColor {
		.systemRed
	}

	var textHighlightedColor: UIColor {
		.darkGray
	}

	var highlightedTextBackgroundColor: UIColor {
		.systemYellow
	}

	var codeTextSize: CGFloat {
		16
	}

	var codeLangSize: CGFloat {
		14
	}

	var codeBlockBackgroundColor: UIColor {
		.systemGray4
	}

	var codeLangColor: UIColor {
		darkColor
	}

	var codeTextColor: UIColor {
		.systemGray
	}

	private var darkColor: UIColor {
		UIColor.color(
			light: UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1),
			dark: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
		)
	}

	private var headerSizes: [CGFloat] {
		[40, 30, 26, 22, 20, 18]
	}

	private var headerColors: [UIColor] {
		[
			darkColor,
			darkColor,
			darkColor,
			darkColor,
			darkColor,
			darkColor
		]
	}

	func headerSize(level: Int) -> CGFloat {
		headerSizes[level - 1]
	}

	func headerColor(level: Int) -> UIColor {
		headerColors[level - 1]
	}
}

public struct Appearance: IAppearance {
	public init() { }
}
