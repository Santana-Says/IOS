//
//  ParameterEncoding.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

typealias Parameters = [String:Any]

protocol ParameterEncoder {
	static func encode(urlRequest: inout URLRequest, with jsonData: Data?) throws
}
