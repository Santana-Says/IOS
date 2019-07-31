//
//  ReviewRequest.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/30/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct ReviewRequest: Codable {
	let review: String
	let userId: Int
	let ratings: Int
	
	enum CodingKeys: String, CodingKey {
		case review
		case ratings
		case userId = "reviewer"
	}
}
