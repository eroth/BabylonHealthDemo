//
//  PostsViewController.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/23/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
	@IBOutlet var postsTableViewObject: PostsTableViewObject!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let babylonHealthAPI = BabylonHealthAPI()
		babylonHealthAPI.getPosts(successCompletion: { posts in
			self.postsTableViewObject.postsDataSource = posts
		}, failureCompletion: { error in
			
		})
		
		postsTableViewObject.didSelectCellClosure = { post in
			babylonHealthAPI.getPostDetails(successCompletion: { users in
				
			}, failureCompletion: { error in
				
			})
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

