//
//  CustomButton.swift
//  Bookr
//
//  Created by Jeffrey Santana on 8/1/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
	
	override func awakeFromNib() {
		setupView()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupView()
	}
	
	func setupView() {
		guard let superWidth = superview?.widthAnchor else { return }
		heightAnchor.constraint(equalToConstant: 50).isActive = true
		widthAnchor.constraint(equalTo: superWidth, multiplier: 0.7, constant: 0).isActive = true
		layer.cornerRadius = layer.frame.height / 2
		
		titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		tintColor = .white
	}
	
}
