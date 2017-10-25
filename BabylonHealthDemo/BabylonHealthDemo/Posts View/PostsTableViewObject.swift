//
//  PostsTableViewObject.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import UIKit

class PostsTableViewObject: NSObject {
	var postsDataSource: [Post] = [] {
		didSet {
			postsTableView.reloadData()
		}
	}
	
	@IBOutlet weak var postsTableView: UITableView! {
		didSet {
			postsTableView.allowsSelection = false
			postsTableView.register(UINib.init(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsTableViewCellReuseIdentifier")
		}
	}
}

extension PostsTableViewObject: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return postsDataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let postsCell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCellReuseIdentifier", for: indexPath) as! PostsTableViewCell
		let post = postsDataSource[indexPath.row]
		postsCell.postTitleLabel.text = post.title
		postsCell.postBodyLabel.text = post.body
		
		return postsCell
	}
}

extension PostsTableViewObject: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Constants.MainPostsView.MAIN_POSTS_TABLEVIEWCELL_HEIGHT
	}
}
