//
//  LoginModel.swift
//  MdEditor
//
//  Created by Alexey Turulin on 11/24/23.
//

import Foundation

/// Encapsulates all data models used for the login process.
enum LoginModel {

	/// Represents a login request containing user credentials.
	struct Request {

		/// User's login identifier.
		var login: String

		/// User's password.
		var password: String
	}
	
	/// Represents the response from a login attempt.
	struct Response {

		/// The result of the login attempt.
		var result: Result<Void, LoginError>
	}
}
