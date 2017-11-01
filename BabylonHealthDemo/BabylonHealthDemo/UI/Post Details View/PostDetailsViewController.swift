//
//  PostDetailsViewController.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/26/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
	@IBOutlet weak var authorLabel: UILabel! {
		didSet {
			authorLabel.text = viewModel.postAuthor
		}
	}
	@IBOutlet weak var bodyLabel: UILabel! {
		didSet {
			bodyLabel.text = viewModel.postBody
		}
	}
	
	@IBOutlet weak var numCommentsLabel: UILabel! {
		didSet {
			numCommentsLabel.text = "\(viewModel.postNumComments) comments"
		}
	}
	let viewModel: PostDetailsViewModel
	
	init(viewModel: PostDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		self.title = "Post Details"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
