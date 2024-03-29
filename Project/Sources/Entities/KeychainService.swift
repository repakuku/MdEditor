//
//  KeychainService.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/26/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

struct KeychainService {

	let account: String

	private let service = "NetworkLayer"

	func saveToken(_ token: Token) -> Bool {

		guard let passData = token.rawValue.data(using: .utf8) else {
			return false
		}

		let keychainItem = [
			kSecAttrService: service,
			kSecAttrAccount: account,
			kSecValueData: passData,
			kSecClass: kSecClassGenericPassword
		] as CFDictionary

		let status = SecItemAdd(keychainItem, nil)

		return status == errSecSuccess
	}

	func getToken() -> Token? {

		let query = [
			kSecAttrService: service,
			kSecAttrAccount: account,
			kSecReturnData: true,
			kSecClass: kSecClassGenericPassword,
			kSecMatchLimit: kSecMatchLimitOne
		] as CFDictionary

		var dataTypeRef: AnyObject?

		let status = SecItemCopyMatching(query, &dataTypeRef)

		if status == errSecSuccess, let data = dataTypeRef as? Data {
			if let rawValue = String(data: data, encoding: .utf8) {
				let token = Token(rawValue: rawValue)
				return token
			} else {
				return nil
			}
		} else {
			return nil
		}
	}

	func deleteToken() -> Bool {

		let query = [
			kSecAttrService: service,
			kSecAttrAccount: account,
			kSecClass: kSecClassGenericPassword
		] as CFDictionary

		let status = SecItemDelete(query)

		return status == errSecSuccess
	}

	func updateToken(_ token: Token) -> Bool {

		guard let passData = token.rawValue.data(using: .utf8) else {
			return false
		}

		let query = [
			kSecAttrService: service,
			kSecAttrAccount: account,
			kSecClass: kSecClassGenericPassword
		] as CFDictionary

		let field = [
			kSecValueData: passData
		] as CFDictionary

		let status = SecItemUpdate(query, field)

		return status == errSecSuccess
	}
}
