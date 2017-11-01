//
//  PostsViewController.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/23/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit
import SVProgressHUD

class PostsViewController: UIViewController {
	@IBOutlet var postsTableViewObject: PostsTableViewProvider!
	var viewModel: PostDetailsViewModel?
	let dataManager = DataProvider()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		displayPosts()
		postsTableViewObject.didSelectCellClosure = { post in
			self.didSelectPostCell(post: post)
		}
	}
	
	func displayPosts() -> Void {
		SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
		SVProgressHUD.show()
		dataManager.retrieveAllPosts(completion: { response in
			SVProgressHUD.dismiss(withDelay: Constants.HUD.DISMISS_TIME, completion: {
				switch response {
				case .success(let posts):
					self.postsTableViewObject.postsDataSource = posts
				case .failure(let error):
					self.showErrorAlert(message: error.localizedDescription)
				}
			})
		})
	}
	
	func didSelectPostCell(post: Post) -> Void {
		SVProgressHUD.show()
		dataManager.retrievePostDetails(userId: post.userId, postId: post.postId, completion: { response in
			SVProgressHUD.dismiss(withDelay: Constants.HUD.DISMISS_TIME, completion: {
				switch response {
				case .success(let postDetails):
					let postDetailsViewModel = PostDetailsViewModel(post: post, postDetails: postDetails)
					let postDetailsVC = PostDetailsViewController(viewModel: postDetailsViewModel)
					self.navigationController?.pushViewController(postDetailsVC, animated: true)
				case .failure(let error):
					self.showErrorAlert(message: error.localizedDescription)
				}
			})
		})
	}
}
