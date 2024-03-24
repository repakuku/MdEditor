//
//  UIColor+DarkMode.swift
//
//
//  Created by Alexey Turulin on 3/23/24.
//

import UIKit

public extension UIColor {
	static func color(light: UIColor, dark: UIColor) -> UIColor {
		if #available(iOS 13, *) {
			return .init { traitCollection in
				return traitCollection.userInterfaceStyle == .dark ? dark : light
			}
		} else {
			return light
		}
	}
}
