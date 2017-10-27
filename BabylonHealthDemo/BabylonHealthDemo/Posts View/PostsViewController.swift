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
	var selectedPostUser: PostDetailsAuthorDisplayable?
	var selectedPost: PostDetailsContentDisplayable?
	var selectedPostComments: [Comment]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let babylonHealthAPI = BabylonHealthAPI()
		babylonHealthAPI.getPosts(successCompletion: { posts in
			self.postsTableViewObject.postsDataSource = posts
		}, failureCompletion: { error in
			
		})
		
		postsTableViewObject.didSelectCellClosure = { post in
			babylonHealthAPI.getPostDetails(userId: post.userId, postId: post.postId, successCompletion: { user, comments in
				self.selectedPost = post
				self.selectedPostUser = user
				self.selectedPostComments = comments
				self.performSegue(withIdentifier: Constants.MainPostsView.PUSH_DETAILS_VIEW_SEGUE_IDENTIFIER, sender: self)
			}, failureCompletion: { error in
				
			})
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let postDetailsVC = segue.destination as? PostDetailsViewController {
			postDetailsVC.delegate = self
		}
	}
}

extension PostsViewController: PostDetailsViewDelegate {
	func postAuthorData() -> PostDetailsAuthorDisplayable? {
		return self.selectedPostUser
	}
	
	func postData() -> PostDetailsContentDisplayable? {
		return self.selectedPost
	}
	
	func numPostComments() -> Int {
		guard let numPostComments = selectedPostComments?.count else {
			return 0
		}
		
		return numPostComments
	}
}
