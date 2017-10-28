//
//  BabylonHealthNetworkingAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

typealias PostsCompletionBlock = (_ post: [Post]) -> Void
typealias FailureCompletionBlock = (_ error: Error) -> Void
typealias PostDetailsCompletionBlock = (_ user: User, _ comments: [Comment]) -> Void
typealias UserInfoCompletionBlock = (_ user: User) -> Void
typealias PostCommentsCompletionBlock = (_ postComments: [Comment]) -> Void

enum APIError: LocalizedError {
	case jsonDecodingError
	
	var errorDescription: String? {
		switch self {
		case .jsonDecodingError:
			return "There was an error decoding the response"
		}
	}
}

struct BabylonHealthNetworkingAPI {
	private let networkingService: NetworkingService
	
	init(networkingService: NetworkingService = VanillaNetworkingService()) {
		self.networkingService = networkingService
	}
	
	@discardableResult
	func getPosts(successCompletion: @escaping PostsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.POSTS_ROUTE, queryParams: nil, successCompletion: { payload in
			let jsonDecoder = JSONDecoder()
			do {
				// API returning malformed 101st array element on occasion
//				let errorArr = try JSONSerialization.jsonObject(with: payload.data, options:[]) as! Array<[String:Any]>
//				let newArr = Array(errorArr[0..<100])
//				let newData = try JSONSerialization.data(withJSONObject: newArr, options:[])
				let posts = try jsonDecoder.decode([Post].self, from: payload.data)
				DispatchQueue.main.async {
					successCompletion(posts)
				}
			} catch let e {
				print(e)
				failureCompletion(APIError.jsonDecodingError)
			}
		}, errorCompletion: { error in
			
		})
	}
	
	@discardableResult
	func getPostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> [URLSessionDataTask] {
		var dataTasks: [URLSessionDataTask] = []
		var user: User?
		var comments: [Comment]?
		var error: Error? // Just using one error if there is one
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		if let postUserTask = getPostUser(userId: userId, successCompletion: { userInfo in
			user = userInfo
			dispatchGroup.leave()
		}, failureCompletion: { getUserError in
			error = getUserError
			dispatchGroup.leave()
		}) {
			dataTasks.append(postUserTask)
		}
		
		dispatchGroup.enter()
		if let postCommentsTask = getPostComments(postId: postId, successCompletion: { postComments in
			comments = postComments
			dispatchGroup.leave()
		}, failureCompletion: { getCommentsError in
			error = getCommentsError
			dispatchGroup.leave()
		}) {
			dataTasks.append(postCommentsTask)
		}
		
		dispatchGroup.notify(queue: .main, execute: {
			guard let user = user else {
				failureCompletion(error!)
				
				return
			}
			guard let comments = comments else {
				failureCompletion(error!)
				
				return
			}
			successCompletion(user, comments)
		})
		
		return dataTasks
	}
	
	private func getPostUser(userId: Int, successCompletion: @escaping UserInfoCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		let userIdString = String(describing: userId)
		let params: [String: String] = ["id": userIdString]
		
		return networkingService.performRequest(route: Constants.Networking.USERS_ROUTE, queryParams: params, successCompletion: { payload in
			print(payload.description)
			let jsonDecoder = JSONDecoder()
			do {
				let user = try jsonDecoder.decode([User].self, from: payload.data).first!
				successCompletion(user)
			} catch let error {
				print(error)
				failureCompletion(APIError.jsonDecodingError)
			}
		}, errorCompletion: { error in
			failureCompletion(error)
			print(error)
		})
	}
	
	private func getPostComments(postId: Int, successCompletion: @escaping PostCommentsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		let postIdString = String(describing: postId)
		let params: [String: String] = ["postId": postIdString]
		
		return networkingService.performRequest(route: Constants.Networking.COMMENTS_ROUTE, queryParams: params, successCompletion: { payload in
			print(payload.description)
			let jsonDecoder = JSONDecoder()
			do {
				let comments = try jsonDecoder.decode([Comment].self, from: payload.data)
				successCompletion(comments)
			} catch let error {
				print(error)
				failureCompletion(APIError.jsonDecodingError)
			}
		}, errorCompletion: { error in
			print(error)
			failureCompletion(error)
		})
	}
}
