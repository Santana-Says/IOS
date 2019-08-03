//
//  NetworkManager.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
	case success
	case authenticationError = "You need to be authenticated first."
	case badRequest = "Bad request"
	case outdated = "The url you requested is outdated."
	case failed = "Network request failed."
	case noData = "Response returned with no data to decode."
	case unableToDecode = "We could no decode the response."
}

enum Result<String> {
	case success
	case failure(String)
}

struct NetworkManager {
	static let shared = NetworkManager()
	
	let router = Router<BookrRouter>()
	
	private init() {
		
	}
	
	func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
		switch response.statusCode {
		case 200...299: return .success
		case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
		case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
		case 600: return .failure(NetworkResponse.outdated.rawValue)
		default: return .failure(NetworkResponse.failed.rawValue)
		}
	}
	
	func getObject<T: Codable>(_ data: Data?, _ response: URLResponse?, _ error: Error?,_ returnType: T.Type) -> (T?, String?) {
		if error != nil {
			return (nil, "Please check your network connection.")
		}
		
		if let response = response as? HTTPURLResponse {
			let result = self.handleNetworkResponse(response)
			switch result {
			case .success:
				guard let responseData = data else {
					return (nil, NetworkResponse.noData.rawValue)
				}
				
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let apiResponse = try decoder.decode(returnType, from: responseData)
					return (apiResponse, nil)
				} catch {
					return (nil, NetworkResponse.unableToDecode.rawValue)
				}
			case .failure(let networkFailureError):
				return (nil, networkFailureError)
			}
		}
		return (nil, NetworkResponse.failed.rawValue)
	}
	
	func getArray<T: Codable>(_ data: Data?, _ response: URLResponse?, _ error: Error?,_ returnType: T.Type) -> ([T]?, String?) {
		if error != nil {
			return (nil, "Please check your network connection.")
		}
		
		if let response = response as? HTTPURLResponse {
			let result = self.handleNetworkResponse(response)
			switch result {
			case .success:
				guard let responseData = data else {
					return (nil, NetworkResponse.noData.rawValue)
				}
				
				do {
					let decoder = JSONDecoder()
					decoder.keyDecodingStrategy = .convertFromSnakeCase
					let apiResponse = try decoder.decode([T].self, from: responseData)
					return (apiResponse, nil)
				} catch {
					return (nil, NetworkResponse.unableToDecode.rawValue)
				}
			case .failure(let networkFailureError):
				return (nil, networkFailureError)
			}
		}
		return (nil, NetworkResponse.failed.rawValue)
	}
}
