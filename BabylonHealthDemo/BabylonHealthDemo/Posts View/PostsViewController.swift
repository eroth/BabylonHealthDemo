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
		dataManager.retrieveAllPosts(completion: { response in
			switch response {
			case .success(let posts):
				self.postsTableViewObject.postsDataSource = posts
			case .failure(let error):
				// TODO need to show alert
				print("here")
			}
		})
		
		postsTableViewObject.didSelectCellClosure = { post in
			dataManager.retrievePostDetails(userId: post.userId, postId: post.postId, completion: { response in
				switch response {
				case .success(let user, let comments):
					let postDetailsViewModel = PostDetailsViewModel(postDetailsData: post, postAuthor: user, postNumComments: comments.count)
					let postDetailsVC = PostDetailsViewController(viewModel: postDetailsViewModel)
					self.navigationController?.pushViewController(postDetailsVC, animated: true)
				case .failure:
					// TODO need to handle error
					print("here")
				}
			})
		}
	}
}
