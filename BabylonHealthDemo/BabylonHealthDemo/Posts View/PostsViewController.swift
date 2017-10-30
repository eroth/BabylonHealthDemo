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
	@IBOutlet var postsTableViewObject: PostsTableViewObject!
	var viewModel: PostDetailsViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
		SVProgressHUD.show()
		let dataManager = DataManager()
		dataManager.retrieveAllPosts(completion: { response in
			SVProgressHUD.dismiss(withDelay: Constants.HUD.DISMISS_TIME, completion: {
				switch response {
				case .success(let posts):
					self.postsTableViewObject.postsDataSource = posts
				case .failure(let error):
					let alert = UIAlertController(title: Constants.Alerts.ERROR_TITLE, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
					let okAction = UIAlertAction(title: Constants.Alerts.OK_ACTION_TITLE, style: UIAlertActionStyle.default, handler: { alertAction in
						self.dismiss(animated: true, completion: nil)
					})
					alert.addAction(okAction)
					self.present(alert, animated: true, completion: nil)
				}
			})
		})
		
		postsTableViewObject.didSelectCellClosure = { post in
			SVProgressHUD.show()
			dataManager.retrievePostDetails(userId: post.userId, postId: post.postId, completion: { response in
				SVProgressHUD.dismiss(withDelay: Constants.HUD.DISMISS_TIME, completion: {
					switch response {
					case .success(let user, let comments):
						let postDetailsViewModel = PostDetailsViewModel(postDetailsData: post, postAuthor: user, postNumComments: comments.count)
						let postDetailsVC = PostDetailsViewController(viewModel: postDetailsViewModel)
						self.navigationController?.pushViewController(postDetailsVC, animated: true)
					case .failure(let error):
						let alert = UIAlertController(title: Constants.Alerts.ERROR_TITLE, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
						let okAction = UIAlertAction(title: Constants.Alerts.OK_ACTION_TITLE, style: UIAlertActionStyle.default, handler: { alertAction in
							self.dismiss(animated: true, completion: nil)
						})
						alert.addAction(okAction)
						self.present(alert, animated: true, completion: nil)
					}
				})
			})
		}
	}
}
