//
//  LexerTests.swift
//
//
//  Created by Alexey Turulin on 3/14/24.
//

import XCTest
@testable import MarkdownPackage

final class LexerTests: XCTestCase {
	
	func testTokenizeLineBreak_withEmptyString_shouldReturnLineBreakToken() {
		
		let sut = makeSUT()

		let input = ""
		let expectedToken: Token = .lineBreak
		
		let token = sut.tokenize(input).first
		
		XCTAssertEqual(token, expectedToken, "Should return .lineBreak token.")
	}
	
	func testTokenizeHeader_withHeaderLevelAndText_shouldReturnCorrectHeaderToken() {
		
		let sut = makeSUT()

		let input1 = "# Header 1"
		let input2 = "## Header 2"
		let input3 = "### Header 3"
		let input4 = "#### Header 4"
		let input5 = "##### Header 5"
		let input6 = "###### Header 6"
		
		let expectedToken1: Token = .header(level: 1, text: Text(text: [.normal(text: "Header 1")]))
		let expectedToken2: Token = .header(level: 2, text: Text(text: [.normal(text: "Header 2")]))
		let expectedToken3: Token = .header(level: 3, text: Text(text: [.normal(text: "Header 3")]))
		let expectedToken4: Token = .header(level: 4, text: Text(text: [.normal(text: "Header 4")]))
		let expectedToken5: Token = .header(level: 5, text: Text(text: [.normal(text: "Header 5")]))
		let expectedToken6: Token = .header(level: 6, text: Text(text: [.normal(text: "Header 6")]))
		
		let token1 = sut.tokenize(input1).first
		let token2 = sut.tokenize(input2).first
		let token3 = sut.tokenize(input3).first
		let token4 = sut.tokenize(input4).first
		let token5 = sut.tokenize(input5).first
		let token6 = sut.tokenize(input6).first
		
		XCTAssertEqual(token1, expectedToken1, "Should return .header token with level '1' and text 'Header 1'.")
		XCTAssertEqual(token2, expectedToken2, "Should return .header token with level '2' and text 'Header 2'.")
		XCTAssertEqual(token3, expectedToken3, "Should return .header token with level '3' and text 'Header 3'.")
		XCTAssertEqual(token4, expectedToken4, "Should return .header token with level '4' and text 'Header 4'.")
		XCTAssertEqual(token5, expectedToken5, "Should return .header token with level '5' and text 'Header 5'.")
		XCTAssertEqual(token6, expectedToken6, "Should return .header token with level '6' and text 'Header 6'.")
	}
	
	func testTokenizeBlockquote_withBlockquoteLevelAndText_shouldReturnCorrectBlockquoteToken() {
		
		let sut = makeSUT()

		let input1 = "> Blockquote 1"
		let input2 = ">> Blockquote 2"
		let input3 = ">>> Blockquote 3"
		let input4 = ">>>> Blockquote 4"
		let input5 = ">>>>> Blockquote 5"
		let input6 = ">>>>>> Blockquote 6"
		
		let expectedToken1: Token = .blockquote(level: 1, text: Text(text: [.normal(text: "Blockquote 1")]))
		let expectedToken2: Token = .blockquote(level: 2, text: Text(text: [.normal(text: "Blockquote 2")]))
		let expectedToken3: Token = .blockquote(level: 3, text: Text(text: [.normal(text: "Blockquote 3")]))
		let expectedToken4: Token = .blockquote(level: 4, text: Text(text: [.normal(text: "Blockquote 4")]))
		let expectedToken5: Token = .blockquote(level: 5, text: Text(text: [.normal(text: "Blockquote 5")]))
		let expectedToken6: Token = .blockquote(level: 6, text: Text(text: [.normal(text: "Blockquote 6")]))
		
		let token1 = sut.tokenize(input1).first
		let token2 = sut.tokenize(input2).first
		let token3 = sut.tokenize(input3).first
		let token4 = sut.tokenize(input4).first
		let token5 = sut.tokenize(input5).first
		let token6 = sut.tokenize(input6).first
		
		XCTAssertEqual(
			token1,
			expectedToken1,
			"Should return .blockquote token with level '1' and text 'Blockquote 1'."
		)
		XCTAssertEqual(
			token2,
			expectedToken2,
			"Should return .blockquote token with level '2' and text 'Blockquote 2'."
		)
		XCTAssertEqual(
			token3,
			expectedToken3,
			"Should return .blockquote token with level '3' and text 'Blockquote 3'."
		)
		XCTAssertEqual(
			token4,
			expectedToken4,
			"Should return .blockquote token with level '4' and text 'Blockquote 4'."
		)
		XCTAssertEqual(
			token5,
			expectedToken5,
			"Should return .blockquote token with level '5' and text 'Blockquote 5'."
		)
		XCTAssertEqual(
			token6,
			expectedToken6,
			"Should return .blockquote token with level '6' and text 'Blockquote 6'."
		)
	}
	
}

extension LexerTests {
	func makeSUT() -> Lexer {
		return Lexer()
	}
}
