//
//  BabylonHealthDatabaseAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

enum APIDatabaseError: LocalizedError {
	case arrayConversionError
	case databaseWriteError
	case databaseReadError
	
	var errorDescription: String? {
		switch self {
		case .arrayConversionError:
			return "There was an error preparing for database write."
		case .databaseWriteError:
			return "There was an error writing to the database."
		case .databaseReadError:
			return "There was an error reading from the database."
		}
	}
}

struct BabylonHealthDatabaseAPI {
	private let databaseService: DatabaseService
	
	init(databaseService: DatabaseService = FirebaseDatabaseService()) {
		self.databaseService = databaseService
	}
	
	func readPosts(successCompletion: PostsCompletionBlock, failureCompletion: FailureCompletionBlock) {
		
	}
	
	func writePosts(posts: [Post], successCompletion: @escaping ()-> Void, failureCompletion: @escaping FailureCompletionBlock) {
		do {
			let array = try posts.asArray()
			let dbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
			self.databaseService.create(configuration: dbConfig, params: array, successCompletion: {
				
			}, failureCompletion: { error in
				failureCompletion(APIDatabaseError.databaseWriteError)
			})
		} catch {
			failureCompletion(APIDatabaseError.arrayConversionError)
		}
	}
}
