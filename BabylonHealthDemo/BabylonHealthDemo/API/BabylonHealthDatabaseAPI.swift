//
//  BabylonHealthDatabaseAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct BabylonHealthDatabaseAPI {
	private let databaseService: DatabaseService
	
	init(databaseService: DatabaseService = FirebaseDatabaseService()) {
		self.databaseService = databaseService
	}
	
	func readPosts(successCompletion: PostsCompletionBlock, failureCompletion: FailureCompletionBlock) {
		
	}
	
	func writePosts(posts: [Post], successCompletion: @escaping ()-> Void, failureCompletion: FailureCompletionBlock) {
		do {
			let array = try posts.asArray()
			let dbConfig = DatabaseConfiguration(path: "posts")
			self.databaseService.create(configuration: dbConfig, params: array, successCompletion: {
				
			}, failureCompletion: { error in
				
			})
		} catch {
			
		}
	}
}
