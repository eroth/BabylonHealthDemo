//
//  BabylonHealthDatabaseAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
	
	func readPosts(successCompletion: @escaping PostsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		let dbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
		self.databaseService.read(configuration: dbConfig, params: [String: Any](), successCompletion: { response in
			if response is DataSnapshot {
				let responseArray = response as! DataSnapshot
				let jsonDecoder = JSONDecoder()
				do {
					let arrayJSONData = try JSONSerialization.data(withJSONObject: responseArray.value!, options: [])
					let posts = try jsonDecoder.decode([Post].self, from: arrayJSONData)
					successCompletion(posts)
				} catch {
					failureCompletion(APIDatabaseError.arrayConversionError)
				}
			}
		}, failureCompletion: { error in
			failureCompletion(APIDatabaseError.databaseReadError)
		})
	}
	
	func readPostDetails(successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		
	}
	
	func writePosts(posts: [Post], successCompletion: @escaping () -> Void, failureCompletion: @escaping FailureCompletionBlock) {
		do {
			let array = try posts.asArray()
			let dbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
			self.databaseService.create(configuration: dbConfig, object: array, successCompletion: {
				
			}, failureCompletion: { error in
				failureCompletion(APIDatabaseError.databaseWriteError)
			})
		} catch {
			failureCompletion(APIDatabaseError.arrayConversionError)
		}
	}
	
	func writePostDetails(user: User, comments: [Comment], successCompletion: @escaping () -> Void, failureCompletion: @escaping FailureCompletionBlock) {
		do {
			let userIdString = String(describing: user.userId)
			let userDict = try user.asDictionary()
//			let fireBaseUserDict = [userDictKey: userDict]
			let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
			self.databaseService.create(configuration: userDbConfig, object: userDict, successCompletion: {

			}, failureCompletion: { error in

			})
			
//			if let firstComment = comments.first {
//				let commentsDictKey = String(describing: firstComment.postId)
//				let commentsArray = try comments.asArray()
//				let fireBaseCommentsDict: [String: Any] = [commentsDictKey: commentsArray]
//				let commentsDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_COMMENTS_PATH, childPath: commentsDictKey)
//				self.databaseService.create(configuration: commentsDbConfig, object: fireBaseCommentsDict, successCompletion: {
//					
//				}, failureCompletion: { error in
//					
//				})
//			}
		} catch {
			
		}
	}
}
