//
//  HeroPageViewController.swift
//  Bookr
//
//  Created by Taylor Lyles on 7/30/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class HeroPageViewController: UIViewController {
	
	//MARK: - IBOutlets
	
	@IBOutlet weak var loginBtn: UIButton!
	@IBOutlet weak var startBtn: UIButton!
	
	//MARK: - Properties
	
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loginBtn.isHidden = true
		startBtn.isHidden = true
		
		checkForLogin()
	}
	
	//MARK: - IBActions
	
	@IBAction func unwindToHeroPage(_ sender: UIStoryboardSegue) {
		
	}
	
	//MARK: - Helpers

	private func checkForLogin() {
		if SettingsController.shared.isSaveCredentials {
			guard let credentials = SettingsController.shared.userCredentials else {
				showLogins()
				return
			}
			NetworkManager.shared.login(credentials: credentials) { (result, error) in
				if let error = error {
					SettingsController.shared.isSaveCredentials = false
					DispatchQueue.main.async {
						self.presentInfoAlert(title: "Login Error", message: error)
					}
					self.showLogins()
				} else if let result = result {
					SettingsController.shared.userToken = result.token
					print("token updated")
					DispatchQueue.main.asyncAfter(deadline: .now()+1) {
						self.performSegue(withIdentifier: "ShowMainSegue", sender: nil)
					}
				}
			}
		} else {
			showLogins()
		}
	}
	
	private func showLogins() {
		loginBtn.isHidden = false
		startBtn.isHidden = false
	}
}
