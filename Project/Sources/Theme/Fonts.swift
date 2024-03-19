//
//  Fonts.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/18/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import MarkdownPackage

struct Fonts: IFonts {

	var normalText: UIFont {
		UIFont.systemFont(ofSize: Sizes.NormalText.size)
	}

	var boldText: UIFont {
		UIFont.boldSystemFont(ofSize: Sizes.BoldText.size)
	}

	var italicText: UIFont {
		UIFont.italicSystemFont(ofSize: Sizes.ItalicText.size)
	}

	var boldAndItalicText: UIFont {

		let font: UIFont

		if let fontDescriptor = UIFontDescriptor
			.preferredFontDescriptor(withTextStyle: .body)
			.withSymbolicTraits([.traitBold, .traitItalic]) {
			font = UIFont(descriptor: fontDescriptor, size: Sizes.BoldAndItalicText.size)
		} else {
			font = UIFont.boldSystemFont(ofSize: Sizes.BoldAndItalicText.size)
		}

		return font
	}

	var codeText: UIFont {
		UIFont(
			name: "Menlo Regular",
			size: Sizes.CodeText.size
		) ?? UIFont.systemFont(ofSize: Sizes.CodeText.size)
	}

	var codeBlock: UIFont {
		UIFont.systemFont(ofSize: Sizes.CodeBlock.size)
	}

	func getHeaderFont(level: Int) -> UIFont {
		guard level >= 0 else {
			return UIFont.systemFont(ofSize: Sizes.Header.headerSize[0])
		}

		guard level <= 5 else {
			return UIFont.systemFont(ofSize: Sizes.Header.headerSize[5])
		}

		return UIFont.systemFont(ofSize: Sizes.Header.headerSize[level])
	}

	private enum Sizes {
		enum Header {
			static let headerSize: [CGFloat] = [40, 30, 26, 22, 20, 18]
		}

		enum NormalText {
			static let size: CGFloat = 18
		}

		enum BoldText {
			static let size: CGFloat = 18
		}

		enum ItalicText {
			static let size: CGFloat = 18
		}

		enum BoldAndItalicText {
			static let size: CGFloat = 18
		}

		enum CodeText {
			static let size: CGFloat = 18
		}

		enum CodeBlock {
			static let size: CGFloat = 18
		}
	}
}
