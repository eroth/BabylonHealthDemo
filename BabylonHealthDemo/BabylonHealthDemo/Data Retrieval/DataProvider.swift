//
//  DataManager.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

enum DataError: LocalizedError {
	case unableToReadAllPostsData
	case unableToReadPostDetailsData
	
	var errorDescription: String? {
		switch self {
		case .unableToReadAllPostsData:
			return "We were unable to retrieve your posts. If this is your first time using the app, the posts must first be downloaded using an active network connection."
		case .unableToReadPostDetailsData:
			return "We were unable to load post details. If you are offline, the item may not have been downloaded yet. Please retry with an active network connection."
		}
	}
}

struct DataProvider {
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
					case .failure:
						completion(ResponseType.failure(DataError.unableToReadAllPostsData))
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
					case .failure:
						completion(ResponseType.failure(DataError.unableToReadPostDetailsData))
					}
				})
			}
		})
	}
}
