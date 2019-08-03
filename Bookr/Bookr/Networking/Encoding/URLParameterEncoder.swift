//
//  URLParameterEncoder.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

//struct URLParameterEncoding: ParameterEncoder {
//	static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
//		guard let url = urlRequest.url else { throw NetworkError.missingURL }
//		
//		if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
//			urlComponents.queryItems = [URLQueryItem]()
//			
//			for (key, value) in parameters {
//				let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
//				urlComponents.queryItems?.append(queryItem)
//			}
//			urlRequest.url = urlComponents.url
//		}
//		
//		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
//			urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
//		}
//	}
//}
