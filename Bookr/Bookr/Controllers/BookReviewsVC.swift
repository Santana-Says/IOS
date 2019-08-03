//
//  BookReviewsVC.swift
//  Bookr
//
//  Created by Jeffrey Santana on 8/1/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class BookReviewsVC: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var tableView: UITableView!
	
	//MARK: - Properties
	
	var bookReference: BookWURL?
	private var book: BookWReviews?
	private var reviews = [Review]()
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		loadBook()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		loadBook()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let postReviewVC = segue.destination as? PostReviewVC {
			guard let book = book, let url = bookReference?.url else { return }
			postReviewVC.book = book
			postReviewVC.bookUrl = url
		}
	}
	
	//MARK: - IBActions
	
	@IBAction func backBtn(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
	
	//MARK: - Helpers
	
	private func loadBook() {
		guard let bookId = bookReference?.id else { return }
		NetworkManager.shared.getBookBy(id: bookId) { (result, error) in
			if let error = error {
				self.presentInfoAlert(title: "Error", message: error)
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
			} else if let result = result {
				self.book = result
				self.reviews = result.reviews.sorted(by: {$0.id > $1.id})
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
	}
}

extension BookReviewsVC: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return reviews.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			guard let rating = book?.averageRatings, let book = bookReference,
				let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsCell") as? BookDetailsCell else { return UITableViewCell() }
			cell.book = (book.title, rating, book.url)
			return cell
		} else if indexPath.section == 1 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as? ReviewCell else { return UITableViewCell() }
			
			cell.review = reviews[indexPath.row]
			return cell
		}
		return UITableViewCell()
	}
}
