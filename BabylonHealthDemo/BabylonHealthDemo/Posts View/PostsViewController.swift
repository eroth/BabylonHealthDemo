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
		
		let dataManager = DataManager()
		dataManager.retrieveAllPosts(successCompletion: { posts in
			self.postsTableViewObject.postsDataSource = posts
		}, failureCompletion: { error in
			
		})
		
		postsTableViewObject.didSelectCellClosure = { post in
			dataManager.retrievePostDetails(userId: post.userId, postId: post.postId, successCompletion: { user, comments in
				let postDetailsViewModel = PostDetailsViewModel(postDetailsData: post, postAuthor: user, postNumComments: comments.count)
				let postDetailsVC = PostDetailsViewController(viewModel: postDetailsViewModel)
				self.navigationController?.pushViewController(postDetailsVC, animated: true)
			}, failureCompletion: { error in

			})
		}
	}
}
