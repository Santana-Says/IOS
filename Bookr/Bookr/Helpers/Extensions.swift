//
//  Extensions.swift
//  Bookr
//
//  Created by Jeffrey Santana on 7/31/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

//MARK: - UITextField

extension UITextField {
	var optionalText: String? {
		let trimmedText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText ?? "").isEmpty ? nil : trimmedText
	}
}

//MARK: - UIViewController

extension UIViewController {
	func fillIn(text field: UITextField, alertMessage: String) -> String? {
		guard let text = field.optionalText else {
			presentInfoAlert(title: "Missing Content", message: alertMessage) { (_) in
				field.becomeFirstResponder()
			}
			return nil
		}
		return text
	}
	
	func presentInfoAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
		let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
		present(alertVC, animated: true, completion: nil)
	}
}

//MARK: - UIImageView

extension UIImageView {
	func setStarRating(of stars: Int) {
		self.image = UIImage(named: "\(stars)StarRating")
	}
	
	func load(url: URL) {
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						self?.image = image
					}
				}
			}
		}
	}
}

//MARK: - Codable

extension Decodable {
	static func decode(data: Data) throws -> Self {
		let decoder = JSONDecoder()
		return try decoder.decode(Self.self, from: data)
	}
}

extension Encodable {
	func encode() throws -> Data {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return try encoder.encode(self)
	}
}
