//
//  DataManager.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct DataManager {
	let networkingAPI = BabylonHealthNetworkingAPI()
	let databaseAPI = BabylonHealthDatabaseAPI()
	
	func retrieveAllPosts(completion: @escaping PostsCompletionBlock) -> Void {
		self.networkingAPI.loadPosts(completion: { networkingResponse in
			switch networkingResponse {
			case .success(let posts):
				completion(ResponseType.success(posts))
				self.databaseAPI.writePosts(posts: posts)
			case .failure:
				self.databaseAPI.readPosts(completion: { databaseResponse in
					switch databaseResponse {
					case .success(let posts):
						completion(ResponseType.success(posts))
					case .failure(let error):
						completion(ResponseType.failure(error))
					}
				})
			}
		})
	}
	
	func retrievePostDetails(userId: Int, postId: Int, completion: @escaping PostDetailsCompletionBlock) {
		self.networkingAPI.loadPostDetails(userId: userId, postId: postId, completion: { networkResponse in
			switch networkResponse {
			case .success(let user, let comments):
				completion(ResponseType.success((user, comments)))
				self.databaseAPI.writePostDetails(user: user, comments: comments)
			case .failure:
				self.databaseAPI.readPostDetails(userId: userId, postId: postId, completion: { databaseResponse in
					switch databaseResponse {
					case .success(let user, let comments):
						completion(ResponseType.success((user, comments)))
					case .failure(let error):
						completion(ResponseType.failure(error))
					}
				})
			}
		})
	}
}
