//
//  HTTPTask.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String:String]

enum HTTPTask {
	case request
	case requestParameters(bodyParameters: Data?, urlParameters: Data?)
	case requestParametersAndHeaders(bodyParameters: Data?, urlParameters: Data?, additionHeaders: HTTPHeaders?)
}
