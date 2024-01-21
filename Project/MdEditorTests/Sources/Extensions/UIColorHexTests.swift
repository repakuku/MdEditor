//
//  TasksTests.swift
//
//
//  Created by Alexey Turulin on 1/13/24.
//

import XCTest
@testable import MdEditor

final class UIColorHexTests: XCTestCase {

	func test_init_withValidParameters_shouldBeInitSuccess() {
		let red: UInt8 = 0x26
		let green: UInt8 = 0xea
		let blue: UInt8 = 0x58
		let alpha: UInt8 = 0xff
		let expectedColor = UIColor(red: 0x26 / 255.0, green: 0xea / 255.0, blue: 0x58 / 255.0, alpha: 1)

		let sut = UIColor(red: red, green: green, blue: blue, alpha: alpha)

		XCTAssertEqual(sut, expectedColor, "")
	}

	func test_init_withWrongInt_shouldBeInitFailure() {
		let color = 0x9728739523
		let expectedColor = UIColor(red: 0x97 / 255.0, green: 0x28 / 255.0, blue: 0x73 / 255.0, alpha: 0x95 / 255.0)

		let sut = UIColor(hex: color)

		XCTAssertNotEqual(sut, expectedColor, "")
	}

	func test_init_withWrongInt_shouldBeInitSuccess() {
		let color = 0x9728739523
		let expectedColor = UIColor(red: 0x28 / 255.0, green: 0x73 / 255.0, blue: 0x95 / 255.0, alpha: 0x23 / 255.0)

		let sut = UIColor(hex: color)

		XCTAssertEqual(sut, expectedColor, "")
	}

	func test_init_withValidHexString_shouldbeInitSuccess() {
		let color = "00ff00"
		let expectedColor = UIColor(red: 0 / 255.0, green: 255 / 255.0, blue: 0 / 255.0, alpha: 1)

		let sut = UIColor(hex: color)

		XCTAssertEqual(sut, expectedColor, "")
	}

	func test_init_withValidhexString2_shouldBeInitSuccess() {
		let color = "26ea58"
		let expectedColor = UIColor(red: 38 / 255.0, green: 234 / 255.0, blue: 88 / 255.0, alpha: 1)

		let sut = UIColor(hex: color)

		XCTAssertEqual(sut, expectedColor, "")
	}

	func test_init_withWronghexString_shouldBeInitFailure() {
		let color = "26ea5w"
		let expectedColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)

		let sut = UIColor(hex: color)

		XCTAssertNotNil(sut)
		XCTAssertEqual(sut, expectedColor, "")
	}
}
