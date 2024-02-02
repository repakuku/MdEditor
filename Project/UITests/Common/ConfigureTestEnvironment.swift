//
//  ConfigureTestEnvironment.swift
//  MdEditorUITests
//
//  Created by Alexey Turulin on 2/2/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

enum ConfigureTestEnvironment {

	static let lang = ["-AppLanguages", "(en)"]
	// TODO: Delete this
//	static let skipLogin = ["-skipLogin"]

	enum InvalidCredentials {
		static let  login = "pa$$32!"
		static let password = "Admin"
	}

	enum ValidCredentials {
		static let login = "Admin"
		static let password = "pa$$32!"
	}
}
