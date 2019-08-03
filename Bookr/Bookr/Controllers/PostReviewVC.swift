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
	@IBOutlet weak var ratingImgView: UIImageView!
	@IBOutlet weak var reviewTextView: UITextView!
	@IBOutlet var starBtnCollection: [StarButton]!
	
	//MARK: - Properties
	
	var book: BookWReviews?
	var bookUrl: String?
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configView()
		configStarButtons()
		reviewTextView.text = ""
	}
	
	//MARK: - IBActions
	
	@IBAction func backBtn(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func submitBtn(_ sender: Any) {
		postReview()
	}
	
	@IBAction func starBtnToggle(_ sender: StarButton) {
		sender.IsStarOn.toggle()
		for star in starBtnCollection {
			if sender.IsStarOn && star.tag < sender.tag {
				star.IsStarOn = sender.IsStarOn
			}
			if !sender.IsStarOn && star.tag > sender.tag {
				star.IsStarOn = sender.IsStarOn
			}
		}
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
	}
	
	private func configStarButtons() {
		starBtnCollection.sort(by: {$0.tag < $1.tag})
	}
	
	private func createReveiew() -> ReviewRequest {
		var rating = 0
		for starBtn in starBtnCollection.reversed() {
			if starBtn.imageView?.image == UIImage(named: "starOn") {
				rating = starBtn.tag
				break
			}
		}
		
		return ReviewRequest(review: reviewTextView.text, userId: 11, ratings: rating)
	}
	
	private func postReview() {
		guard let book = book else { return }
		NetworkManager.shared.post(review: createReveiew(), onBookId: book.id) { (result, error) in
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
