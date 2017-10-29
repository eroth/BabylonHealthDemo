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
	case conversionError
	case databaseWriteError
	case databaseReadError
	
	var errorDescription: String? {
		switch self {
		case .conversionError:
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
		
		databaseService.read(configuration: dbConfig, successCompletion: { response in
			if response is DataSnapshot, let responseArray = response as! DataSnapshot {
				let responseArray = response as! DataSnapshot
				let jsonDecoder = JSONDecoder()
				do {
					let arrayJSONData = try JSONSerialization.data(withJSONObject: responseArray.value!, options: [])
					let posts = try jsonDecoder.decode([Post].self, from: arrayJSONData)
					successCompletion(posts)
				} catch {
					failureCompletion(APIDatabaseError.conversionError)
				}
			}
		}, failureCompletion: { error in
			failureCompletion(APIDatabaseError.databaseReadError)
		})
	}
	
	func readPostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		let userIdString = String(describing: userId)
		let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
		
		databaseService.read(configuration: userDbConfig, successCompletion: { response in
			print("here")
		}, failureCompletion: { error in
			
		})
	}
	
	func writePosts(posts: [Post], successCompletion: @escaping () -> Void, failureCompletion: @escaping FailureCompletionBlock) {
		var postsDict: [String: Any] = [:]
		posts.forEach {
			do {
				let postDict = try $0.asDictionary()
				postsDict[String(describing: $0.postId)] = postDict
			} catch {
				failureCompletion(APIDatabaseError.conversionError)
			}
		}
		let postDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
		
		databaseService.create(configuration: postDbConfig, object: postsDict, successCompletion: {
			
		}, failureCompletion: { error in
			failureCompletion(APIDatabaseError.databaseWriteError)
		})
	}
	
	func writePostDetails(user: User, comments: [Comment], successCompletion: @escaping () -> Void, failureCompletion: @escaping FailureCompletionBlock) {
		do {
			let userIdString = String(describing: user.userId)
			let userDict = try user.asDictionary()
			let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
			
			databaseService.create(configuration: userDbConfig, object: userDict, successCompletion: {

			}, failureCompletion: { error in

			})
			
			if let firstComment = comments.first {
				let commentIdString = String(describing: firstComment.postId)
				let commentsArray = try comments.asArray()
				let commentsDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_COMMENTS_PATH, childPath: commentIdString)
				
				databaseService.create(configuration: commentsDbConfig, object: commentsArray, successCompletion: {
					
				}, failureCompletion: { error in
					
				})
			}
		} catch {
			
		}
	}
}
