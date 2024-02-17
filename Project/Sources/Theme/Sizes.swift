//
//  Colors.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
enum Sizes {

	static let cornerRadius: CGFloat = 6
	static let borderWidth: CGFloat = 1
	static let topInset: CGFloat = 180.0

	enum Padding {
		static let micro: CGFloat = 4
		static let half: CGFloat = 8
		static let normal: CGFloat = 16
		static let double: CGFloat = 32
	}

	enum L {
		static let width: CGFloat = 200
		static let height: CGFloat = 50
		static let widthMultiplier: CGFloat = 0.9
		static let icon: CGFloat = 10
	}

	enum M {
		static let width: CGFloat = 100
		static let height: CGFloat = 40
	}

	enum S {
		static let width: CGFloat = 80
		static let height: CGFloat = 30
	}

	enum CollectionView {
		static let height: CGFloat = 200
		static let cellSize = CGSize(width: 100, height: 150)

		static let fontSize: CGFloat = 10
		static let labelHeight: CGFloat = 15
	}

	enum Button {
		static let imageReservation: CGFloat = 30
	}
}
// swiftlint:enable type_name
