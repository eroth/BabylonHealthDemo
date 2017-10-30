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
	
	func retrieveAllPosts(successCompletion: @escaping ([Post]) -> Void, failureCompletion: @escaping (Error) -> Void) {
		self.networkingAPI.loadPosts(successCompletion: { posts in
			self.databaseAPI.writePosts(posts: posts, successCompletion: {
				
			}, failureCompletion: { error in

			})
			successCompletion(posts)
		}, failureCompletion: { error in
			self.databaseAPI.readPosts(successCompletion: { posts in
				successCompletion(posts)
			}, failureCompletion: { error in
				failureCompletion(error)
			})
		})
	}
	
	func retrievePostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		self.networkingAPI.loadPostDetails(userId: userId, postId: postId, successCompletion: { user, comments in
			self.databaseAPI.writePostDetails(user: user, comments: comments, successCompletion: {
				
			}, failureCompletion: { error in
				
			})
			successCompletion(user, comments)
		}, failureCompletion: { error in
			self.databaseAPI.readPostDetails(userId: userId, postId: postId, successCompletion: { user, comments in
				successCompletion(user, comments)
			}, failureCompletion: { error in
				print("here")
			})
		})
	}
}
