//
//  PostsTableViewObject.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import UIKit

typealias DidSelectCellClosure = (_ postData: Post) -> Void

class PostsTableViewProvider: NSObject {
	var postsDataSource: [Post] = [] {
		didSet {
			postsTableView.reloadData()
		}
	}
	
	@IBOutlet weak var postsTableView: UITableView! {
		didSet {
			let postTableViewCellClassName = String(describing: PostsTableViewCell.self)
			postsTableView.register(UINib.init(nibName: postTableViewCellClassName, bundle: nil), forCellReuseIdentifier: Constants.MainPostsView.POSTS_TABLEVIEWCELL_REUSE_IDENTIFIER)
		}
	}
	
	var didSelectCellClosure: DidSelectCellClosure?
}

extension PostsTableViewProvider: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postsDataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let postsCell = tableView.dequeueReusableCell(withIdentifier: Constants.MainPostsView.POSTS_TABLEVIEWCELL_REUSE_IDENTIFIER, for: indexPath) as! PostsTableViewCell
		let post = postsDataSource[indexPath.row]
		postsCell.postTitleLabel.text = post.title
		postsCell.postBodyLabel.text = post.body
		
		return postsCell
	}
}

extension PostsTableViewProvider: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.MainPostsView.MAIN_POSTS_TABLEVIEWCELL_HEIGHT
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let post = postsDataSource[indexPath.row]
		if let returnClosure = didSelectCellClosure {
			returnClosure(post)
		}
	}
}
