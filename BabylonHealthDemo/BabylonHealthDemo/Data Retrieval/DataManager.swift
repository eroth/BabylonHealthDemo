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
			successCompletion(posts)
		}, failureCompletion: { error in
			
		})
	}
	
	func retrievePostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		self.networkingAPI.loadPostDetails(userId: userId, postId: postId, successCompletion: { user, comments in
			successCompletion(user, comments)
		}, failureCompletion: { error in
			
		})
	}
}
