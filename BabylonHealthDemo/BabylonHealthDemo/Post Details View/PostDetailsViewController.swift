//
//  PostDetailsViewController.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/26/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

protocol PostDetailsViewDelegate: class {
	func postAuthorData() -> PostDetailsAuthorDisplayable?
	func postData() -> PostDetailsContentDisplayable?
	func numPostComments() -> Int
}

class PostDetailsViewController: UIViewController {
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	@IBOutlet weak var numCommentsLabel: UILabel!
	weak var delegate: PostDetailsViewDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		populateUI()
		
	}
	
	func populateUI() -> Void {
		if let authorData = delegate?.postAuthorData() {
			authorLabel.text = authorData.name
		}
		if let content = delegate?.postData() {
			bodyLabel.text = content.body
		}
		
		if let numComments = delegate?.numPostComments() {
			numCommentsLabel.text = "\(numComments) comments"
		}
	}
}
