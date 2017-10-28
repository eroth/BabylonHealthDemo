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
		self.networkingAPI.getPosts(successCompletion: { posts in
			successCompletion(posts)
		}, failureCompletion: { error in
			
		})
	}
}
