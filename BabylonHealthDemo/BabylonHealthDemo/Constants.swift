//
//  Constants.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
	struct Networking {
		static let API_HOST = "jsonplaceholder.typicode.com"
		static let POSTS_ROUTE = "/posts"
		static let USERS_ROUTE = "/users"
		static let COMMENTS_ROUTE = "/comments"
	}
	
	struct MainPostsView {
		static let MAIN_POSTS_TABLEVIEWCELL_HEIGHT = CGFloat(130)
		static let POSTS_TABLEVIEWCELL_REUSE_IDENTIFIER = "PostsTableViewCellReuseIdentifier"
		static let PUSH_DETAILS_VIEW_SEGUE_IDENTIFIER = "ShowPostDetailsSegueIdentifier"
	}
	
	struct Database {
		static let FIREBASE_POSTS_PATH = "posts"
		static let FIREBASE_USERS_PATH = "users"
		static let FIREBASE_COMMENTS_PATH = "comments"
		static let FIREBASE_OPERATION_TIMEOUT = DispatchTimeInterval.seconds(5)
	}
}
