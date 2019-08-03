//
//  ReviewCell.swift
//  Bookr
//
//  Created by Jeffrey Santana on 8/1/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var starRatingImgView: UIImageView!
	@IBOutlet weak var subjectLbl: UILabel!
	@IBOutlet weak var reviewLbl: UILabel!
	
	var review: Review? {
		didSet {
			configCell()
		}
	}
	
	private func configCell() {
		guard let review = review else { return }
		
		#warning("Add line seperator after each review")
		NetworkManager.shared.getUserBy(id: review.userId) { (result, error) in
			if let error = error {
				print(error)
			} else if let result = result {
				DispatchQueue.main.async {
					self.nameLbl.text = "\(result.firstName.capitalized) \(result.lastName.capitalized)"
					self.starRatingImgView.setStarRating(of: review.ratings)
					self.reviewLbl.text = review.review
				}
			}
		}
	}
}
