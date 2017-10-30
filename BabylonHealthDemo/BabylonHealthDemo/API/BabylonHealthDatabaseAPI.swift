//
//  BabylonHealthDatabaseAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias DatabaseWriteCompletionBlock = (ResponseType<Bool>) -> Void

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
	
	func readPosts(completion: @escaping PostsCompletionBlock) -> Void {
		let dbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
		databaseService.read(configuration: dbConfig, completion: { response in
			switch response {
			case .success(let result):
				guard
					let postsDataArray = try? JSONSerialization.data(withJSONObject: result.data, options: []),
					let posts = try? JSONDecoder().decode([Post].self, from: postsDataArray) else {
						completion(ResponseType.failure(APIDatabaseError.conversionError))
						return
				}
				completion(ResponseType.success(posts))
			case .failure(let error):
				completion(ResponseType.failure(error))
			}
		})
	}
	
	func readPostDetails(userId: Int, postId: Int, completion: @escaping PostDetailsCompletionBlock) -> Void {
		let userIdString = String(describing: userId)
		let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
		var user: User?
		var comments: [Comment]?
		var responseError: Error? // Just using one error if there is one
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		databaseService.read(configuration: userDbConfig, completion: { userResponse in
			switch userResponse {
			case .success(let result):
				guard
					let userDataDict = try? JSONSerialization.data(withJSONObject: result.data, options: []),
					let tempUser = try? JSONDecoder().decode(User.self, from: userDataDict)
				else {
					responseError = APIDatabaseError.conversionError
					return
				}
				user = tempUser
			case .failure(let error):
				responseError = error
			}
			dispatchGroup.leave()
		})
		
		let postIdString = String(describing: postId)
		let postDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_COMMENTS_PATH, childPath: postIdString)
		
		dispatchGroup.enter()
		databaseService.read(configuration: postDbConfig, completion: { commentsResponse in
			switch commentsResponse {
			case .success(let result):
				guard
					let commentsDataArray = try? JSONSerialization.data(withJSONObject: result.data, options: []),
					let commentsArray = try? JSONDecoder().decode([Comment].self, from: commentsDataArray)
				else {
					responseError = APIDatabaseError.conversionError
					return
				}
				comments = commentsArray
			case .failure(let error):
				responseError = error
			}
			dispatchGroup.leave()
		})
		
		dispatchGroup.notify(queue: .main, execute: {
			guard
				let user = user,
				let comments = comments
			else {
				completion(ResponseType.failure(responseError!))
				return
			}
			completion(ResponseType.success((user, comments)))
		})
	}
	
	func writePosts(posts: [Post], completion: (DatabaseWriteCompletionBlock)? = nil) -> Void {
		guard let array = try? posts.asArray() else {
			completion?(ResponseType.failure(APIDatabaseError.conversionError))
			return
		}
		
		let dbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_POSTS_PATH)
		databaseService.create(configuration: dbConfig, object: array, completion: { response in
			switch response {
			case .success:
				completion?(ResponseType.success(true))
			case .failure(let error):
				completion?(ResponseType.failure(error))
			}
		})
	}
	
	func writePostDetails(user: User, comments: [Comment], completion: (DatabaseWriteCompletionBlock)? = nil) -> Void {
		let userIdString = String(describing: user.userId)
		guard let userDict = try? user.asDictionary() else {
			completion?(ResponseType.failure(APIDatabaseError.conversionError))
			return
		}
		
		let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
		databaseService.create(configuration: userDbConfig, object: userDict, completion: { response in
			switch response {
			case .success:
				completion?(ResponseType.success(true))
			case .failure(let error):
				completion?(ResponseType.failure(error))
			}
		})
		
		guard
			let firstComment = comments.first,
			let commentsArray = try? comments.asArray()
		else {
			completion?(ResponseType.failure(APIDatabaseError.conversionError))
			return
		}
		
		let commentIdString = String(describing: firstComment.postId)
		let commentsDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_COMMENTS_PATH, childPath: commentIdString)
		databaseService.create(configuration: commentsDbConfig, object: commentsArray, completion: { response in
			switch response {
			case .success:
				completion?(ResponseType.success(true))
			case .failure(let error):
				completion?(ResponseType.failure(error))
			}
		})
	}
}
