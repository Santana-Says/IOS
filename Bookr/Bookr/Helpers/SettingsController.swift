//
//  SettingsController.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/30/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import KeychainAccess

class SettingsController {
	static let shared = SettingsController()
	
	private let defaults = UserDefaults.standard
	private let keychain = Keychain(service: "com.build-week.Bookr")
	
	private let tokenKey = "token_key"
	private let userIdKey = "user_id_key"
	private let userEmailKey = "user_email_key"
	private let userPasswordKey = "user_password_key"
	private let saveProfileKey = "save_profile_key"
	
	private(set) var userToken: String? {
		get {
			return keychain[tokenKey]
		}
		set {
			guard let newToken = newValue else {
				keychain[tokenKey] = nil
				return
			}
			keychain[tokenKey] = newToken
		}
	}
	
	private(set) var loggedInUser: User?
	
	private(set) var userCredentials: LoginRequest? {
		get {
			guard let email = keychain[userEmailKey], let password = keychain[userPasswordKey] else { return nil }
			return LoginRequest(email: email, password: password)
		}
		set {
			guard let newValue = newValue else {
				keychain[userEmailKey] = nil
				keychain[userPasswordKey] = nil
				return
			}
			keychain[userEmailKey] = newValue.email
			keychain[userPasswordKey] = newValue.password
		}
	}
	
	var isSaveCredentials: Bool {
		get {
			guard let isSaved = defaults.value(forKey: saveProfileKey) as? Bool else { return false }
			return isSaved
		}
		set {
			if !newValue {
				userCredentials = nil
			}
			defaults.set(newValue, forKey: saveProfileKey)
		}
	}
	
	//MARK: Life Cycle
	
	private init() {
		//This allows to clear the keychain when is a fresh installation, in order to remove the saved passwords.
		let freshInstallationKey = "FreshInstallation"
		if defaults.value(forKey: freshInstallationKey) == nil {
			_ = try? keychain.removeAll()
			defaults.set(false, forKey: freshInstallationKey)
		}
	}
	
	func persist(credentials: LoginRequest) {
		if isSaveCredentials {
			userCredentials = credentials
		}
	}
	
	func loginProcedure(_ login: Login) {
		loggedInUser = login.user
		userToken = login.token
	}
}
