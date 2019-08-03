//
//  StarButton.swift
//  Bookr
//
//  Created by Jeffrey Santana on 8/1/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

@IBDesignable
class StarButton: UIButton {
	
	@IBInspectable
	var IsStarOn: Bool = false {
		didSet{
			setupView()
		}
	}
	
	override func awakeFromNib() {
		setupView()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupView()
	}
	
	func setupView() {
		setImage(UIImage(named: IsStarOn ? "starOn" : "starOff"), for: .normal)
	}
	
}
