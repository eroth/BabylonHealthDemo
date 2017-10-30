//
//  UIViewController+Alert.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/30/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

extension UIViewController {
	func showErrorAlert(message: String) {
		showAlert(title: Constants.Alerts.ERROR_TITLE, message: message)
	}
	
	func showAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(OKAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
