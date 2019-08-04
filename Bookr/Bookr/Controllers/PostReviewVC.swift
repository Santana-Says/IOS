//
//  PostReviewVC.swift
//  Bookr
//
//  Created by Jeffrey Santana on 8/1/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class PostReviewVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var coverImgView: UIImageView!
	@IBOutlet weak var titleLbl: UILabel!
	@IBOutlet weak var authorLbl: UILabel!
	@IBOutlet weak var publisherLbl: UILabel!
	@IBOutlet weak var reviewTextView: UITextView!
	@IBOutlet weak var ratingImgView: UIImageView!
	
	//MARK: - Properties
	
	var book: BookWReviews?
	var bookUrl: String?
	private var rating = 1
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configView()
	}
	
	//MARK: - IBActions
	
	@IBAction func backBtn(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func submitBtn(_ sender: Any) {
		postReview()
	}
	
	@IBAction func setStarRatingBtnAction(_ sender: UIButton) {
		rating = sender.tag
		ratingImgView.image = UIImage(named: "\(sender.tag)StarRating")
	}
	
	//MARK: - Helpers
	
	private func configView() {
		guard let book = book, let urlString = bookUrl, let imgURL = URL(string: urlString) else { return }
		
		coverImgView.load(url: imgURL)
		titleLbl.text = book.title
		authorLbl.text = book.author
		publisherLbl.text = "\(book.publisher) \(book.published)"
		ratingImgView.setStarRating(of: book.averageRatings)
		
		reviewTextView.layer.borderWidth = 1
		reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
		reviewTextView.text = ""
		
		ratingImgView.image = UIImage(named: "1StarRating")
		
	}
	
	private func postReview() {
		guard let book = book, let userId = SettingsController.shared.loggedInUser?.id else { return }
		let review = ReviewRequest(review: reviewTextView.text, userId: userId, ratings: rating)
		
		NetworkManager.shared.post(review: review, onBookId: book.id) { (result, error) in
			if let error = error {
				DispatchQueue.main.async {
					self.presentInfoAlert(title: "Error", message: error)
				}
			} else if result != nil {
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}

}
