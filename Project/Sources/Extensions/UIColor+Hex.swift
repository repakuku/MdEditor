//
//  UIColor+Hex.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

extension UIColor {

	/// Initializes a UIColor object with the specified red, green, blue, and alpha values.
	/// - Parameters:
	///   - red: The red component of the color, specified as a value from 0 to 255.
	///   - green: The green component of the color, specified as a value from 0 to 255.
	///   - blue: The blue component of the color, specified as a value from 0 to 255.
	///   - alpha: The alpha component of the color, specified as a value from 0 to 255.
	convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
		self.init(
			red: CGFloat(red) / 255.0,
			green: CGFloat(green) / 255.0,
			blue: CGFloat(blue) / 255.0,
			alpha: CGFloat(alpha) / 255.0
		)
	}

	/// Initializes a UIColor object with a hexadecimal integer.
	/// - Parameter hex: A hexadecimal representation of the color.
	convenience init(hex: Int) {
		if hex > 0xffffff {
			self.init(
				red: UInt8((hex >> 24) & 0xff),
				green: UInt8((hex >> 16) & 0xff),
				blue: UInt8((hex >> 8) & 0xff),
				alpha: UInt8(hex & 0xff)
			)
		} else {
			self.init(
				red: UInt8((hex >> 16) & 0xff),
				green: UInt8((hex >> 8) & 0xff),
				blue: UInt8(hex & 0xff)
			)
		}
	}

	/// Initializes a UIColor object with a hexadecimal string.
	/// - Parameter hex: A string representation of the hexadecimal color.
	convenience init(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

		let hex = Int(hexSanitized, radix: 16) ?? 0

		self.init(hex: Int(hex))
	}

	/// Converts the UIColor to a hexadecimal string representation.
	/// - Parameter withAlpha: A Boolean value that determines whether the alpha value 
	/// is included in the hexadecimal string.
	/// - Returns: A hexadecimal string representation of the color, optionally including the alpha value.
	func toHex(withAlpha: Bool = false) -> String? {
		guard let components = cgColor.components, components.count >= 3 else {
			return nil
		}

		let red = Float(components[0])
		let green = Float(components[1])
		let blue = Float(components[2])
		var alpha = Float(1.0)

		if components.count >= 4 {
			alpha = Float(components[3])
		}

		if withAlpha {
			return String(
				format: "%02lX%02lX%02lX%02lX",
				lroundf(red * 255),
				lroundf(green * 255),
				lroundf(blue * 255),
				lroundf(alpha * 255)
			)
		} else {
			return String(
				format: "%02lX%02lX%02lX",
				lroundf(red * 255),
				lroundf(green * 255),
				lroundf(blue * 255)
			)
		}
	}
}
