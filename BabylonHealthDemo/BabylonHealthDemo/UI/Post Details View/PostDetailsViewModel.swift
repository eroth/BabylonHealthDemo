//
//  PostDetailsViewModel.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/30/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct PostDetailsViewModel {
	let postAuthor: String
	let postBody: String
	let postNumComments: Int
	
	init(post: Post, user: User, postComments: [Comment]) {
		postAuthor = user.name
		postBody = post.body
		postNumComments = postComments.count
	}
}
