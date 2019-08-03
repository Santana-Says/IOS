//
//  BookrRouter.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/29/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum BookrRouter {
	case register(request: RegisterRequest)
	case login(request: LoginRequest)
	case getUserBy(id: Int)
	case getBooks
	case getBookBy(id: Int)
	case deleteBookBy(id: Int)
	case postReview(bookId: Int, request: ReviewRequest)
	case getReviewBy(id: Int)
	case getReviewsBy(userId: Int)
	case putReviewBy(id: Int, request: ReviewRequest)
	case deleteReviewBy(id: Int)
	case addBook(request: BookRequest)
}

extension BookrRouter: EndPointType {
	var baseURL: URL {
		guard let url = URL(string: "https://bookr-bw.herokuapp.com/api/") else { fatalError("baseURL could not be configured")}
		return url
	}
	
	var path: String {
		switch self {
		case .register:
			return "register"
		case .login:
			return "login"
		case .getUserBy(let id):
			return "users/\(id)"
		case .getBooks:
			return "books"
		case .getBookBy(let id),
			 .deleteBookBy(let id):
			return "books/\(id)"
		case .postReview(let bookId, _):
			return "books/\(bookId)/review"
		case .addBook(let book):
			return "books/\(book.bookId)/shelf"
		case .getReviewsBy(let userId):
			return "user/\(userId)/reviews"
		case .getReviewBy(let id),
			 .putReviewBy(let id, _),
			 .deleteReviewBy(let id):
			return "reviews/\(id)"
		}
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .register,
			 .login,
			 .postReview:
			return .post
		case .getUserBy,
			 .getBooks,
			 .getBookBy,
			 .getReviewBy,
			 .getReviewsBy:
			return .get
		case .putReviewBy,
			 .addBook:
			return .put
		case .deleteBookBy,
			 .deleteReviewBy:
			return.delete
		}
	}
	
	var task: HTTPTask {
		switch self {
		case .login(let data):
			let json = try? data.encode()
			return .requestParameters(bodyParameters: json, urlParameters: nil)
		case .register(let data):
			let json = try? data.encode()
			return .requestParameters(bodyParameters: json, urlParameters: nil)
		case .postReview(_, let data):
			let json = try? data.encode()
			return .requestParameters(bodyParameters: json, urlParameters: nil)
		case .addBook(let data):
			let json = try? data.encode()
			return .requestParameters(bodyParameters: json, urlParameters: nil)
		default:
			return .request
		}
	}
	
	var headers: HTTPHeaders? {
		switch self {
		default:
			return nil
		}
	}
}
