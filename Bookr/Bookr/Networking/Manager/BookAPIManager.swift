//
//  BookAPIManager.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/30/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

extension NetworkManager {
	func getAllBooks(completion: @escaping (_ books: [BookWURL]?, _ error: String?) -> ()) {
		router.request(.getBooks) { (data, response, error) in
			let returnRequest = self.getArray(data, response, error, BookWURL.self)
			completion(returnRequest.0, returnRequest.1)
		}
	}
	
	func getBookBy(id: Int, completion: @escaping (_ book: BookWReviews?, _ error: String?) -> ()) {
		router.request(.getBookBy(id: id)) { (data, response, error) in
			let returnRequest = self.getObject(data, response, error, BookWReviews.self)
			completion(returnRequest.0, returnRequest.1)
		}
	}
	
	func post(review: ReviewRequest, onBookId id: Int, completion: @escaping (_ book: Review?, _ error: String?) -> ()) {
		router.request(.postReview(bookId: id, request: review)) { (data, response, error) in
			let returnRequest = self.getArray(data, response, error, Review.self)
			completion(returnRequest.0?.first, returnRequest.1)
		}
	}
}
