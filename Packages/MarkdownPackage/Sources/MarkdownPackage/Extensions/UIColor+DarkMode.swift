//
//  UIColor+DarkMode.swift
//
//
//  Created by Alexey Turulin on 3/23/24.
//

import UIKit

public extension UIColor {
	convenience init(dark: UIColor, light: UIColor) {
		self.init(ciColor: .black)
	}
}
