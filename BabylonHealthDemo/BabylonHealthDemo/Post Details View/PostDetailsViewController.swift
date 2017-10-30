//
//  PostDetailsViewController.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/26/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	@IBOutlet weak var numCommentsLabel: UILabel!
	let viewModel: PostDetailsViewModel
	
	init(viewModel: PostDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		authorLabel.text = viewModel.postAuthor.name
		bodyLabel.text = viewModel.postDetailsData.body
		numCommentsLabel.text = "\(viewModel.postNumComments) comments"
	}
}
