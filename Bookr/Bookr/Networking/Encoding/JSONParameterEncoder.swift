//
//  JSONParameterEncoder.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
	static func encode(urlRequest: inout URLRequest, with jsonData: Data?) throws {
		do {
			urlRequest.httpBody = jsonData
			if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
				urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
				urlRequest.setValue(SettingsController.shared.userToken, forHTTPHeaderField: "Authorization")
			}
		}
	}
}
