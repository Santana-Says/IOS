//
//  Router.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
	private var task: URLSessionTask?
	
	func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
		let session = URLSession.shared
		do {
			let request = try self.buildRequest(from: route)
			task = session.dataTask(with: request, completionHandler: { (data, response, error) in
				completion(data, response, error)
			})
		} catch {
			completion(nil, nil, error)
		}
		
		self.task?.resume()
	}
	
	func cancel() {
		task?.cancel()
	}
	
	private func buildRequest(from route: EndPointType) throws -> URLRequest {
		var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		
		request.httpMethod = route.httpMethod.rawValue
		do {
			switch route.task {
			case .request:
				request.setValue("aplication/json", forHTTPHeaderField: "Content-Type")
				request.setValue(SettingsController.shared.userToken, forHTTPHeaderField: "Authorization")
			case .requestParameters(let bodyParameters, let urlParameters):
				try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
			case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
				addAdditionalHeaders(additionalHeaders, request: &request)
				try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
			}
			return request
		} catch {
			throw error
		}
	}
	
	private func configureParameters(bodyParameters: Data?, urlParameters: Data?, request: inout URLRequest) throws {
		do {
			if let bodyParameters = bodyParameters {
				try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
			}
//			if let urlParameters = urlParameters {
//				try URLParameterEncoding.encode(urlRequest: &request, with: urlParameters)
//			}
		} catch {
			throw error
		}
	}
	
	private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
		guard let headers = additionalHeaders else { return }
		for (key, value) in headers {
			request.setValue(value, forHTTPHeaderField: key)
		}
	}
}
