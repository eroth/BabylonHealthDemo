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
			let snapshot = response as! DataSnapshot
			do {
				let postsDataArray = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
				let posts = try JSONDecoder().decode([Post].self, from: postsDataArray)
				successCompletion(posts)
			} catch {
				failureCompletion(APIDatabaseError.conversionError)
			}

		}, failureCompletion: { error in
			failureCompletion(APIDatabaseError.databaseReadError)
		})
	}
	
	func readPostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) {
		let userIdString = String(describing: userId)
		let userDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_USERS_PATH, childPath: userIdString)
		var user: User?
		var comments: [Comment]?
		var responseError: Error? // Just using one error if there is one
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		databaseService.read(configuration: userDbConfig, successCompletion: { response in
			let snapshot = response as! DataSnapshot
			do {
				let userDataDict = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
				let tempUser = try JSONDecoder().decode(User.self, from: userDataDict)
				user = tempUser
				dispatchGroup.leave()
			} catch {
				responseError = APIDatabaseError.conversionError
				dispatchGroup.leave()
			}
		}, failureCompletion: { error in
			responseError = APIDatabaseError.databaseReadError
			dispatchGroup.leave()
		})
		
		let postIdString = String(describing: postId)
		let postDbConfig = DatabaseConfiguration(path: Constants.Database.FIREBASE_COMMENTS_PATH, childPath: postIdString)
		
		dispatchGroup.enter()
		databaseService.read(configuration: postDbConfig, successCompletion: { response in
			let snapshot = response as! DataSnapshot
			do {
				let commentsDataArray = try JSONSerialization.data(withJSONObject: snapshot.value!, options: [])
				let commentsArray = try JSONDecoder().decode([Comment].self, from: commentsDataArray)
				comments = commentsArray
				dispatchGroup.leave()
			} catch {
				responseError = APIDatabaseError.conversionError
				dispatchGroup.leave()
			}
		}, failureCompletion: { error in
			responseError = APIDatabaseError.databaseReadError
			dispatchGroup.leave()
		})
		
		dispatchGroup.notify(queue: .main, execute: {
			guard let user = user else {
				failureCompletion(responseError!)
				return
			}
			guard let comments = comments else {
				failureCompletion(responseError!)
				return
			}
			successCompletion(user, comments)
		})
		
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
			failureCompletion(APIDatabaseError.conversionError)
		}
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
