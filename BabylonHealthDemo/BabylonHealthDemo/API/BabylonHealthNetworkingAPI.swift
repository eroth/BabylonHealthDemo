//
//  BabylonHealthNetworkingAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

typealias PostDetails = (user: User, comments: [Comment])
typealias PostsCompletionBlock = (ResponseType<([Post])>) -> Void
typealias PostDetailsCompletionBlock = (ResponseType<PostDetails>) -> Void
typealias UserInfoCompletionBlock = (ResponseType<User>) -> Void
typealias PostCommentsCompletionBlock = (ResponseType<[Comment]>) -> Void

enum APINetworkingError: LocalizedError {
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
	func loadPosts(completion: @escaping PostsCompletionBlock) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.POSTS_ROUTE, queryParams: nil, completion: { response in
			switch response {
			case .success(let payload):
				do {
					let posts = try JSONDecoder().decode([Post].self, from: payload.data)
					completion(ResponseType.success(posts))
				} catch let e {
					print(e)
					completion(ResponseType.failure(APINetworkingError.jsonDecodingError))
				}
			case .failure(let error):
				completion(ResponseType.failure(error))
			}
		})
	}
	
	@discardableResult
	func loadPostDetails(userId: Int, postId: Int, completion: @escaping PostDetailsCompletionBlock) -> [URLSessionDataTask] {
		var dataTasks: [URLSessionDataTask] = []
		var user: User?
		var comments: [Comment]?
		var responseError: Error? // Just using one error if there is one
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		if let postUserTask = getPostUser(userId: userId, completion: { response in
			switch response {
			case .success(let userResponse):
				user = userResponse
			case .failure(let error):
				responseError = error
			}
			dispatchGroup.leave()
		}) {
			dataTasks.append(postUserTask)
		}
		
		dispatchGroup.enter()
		if let postCommentsTask = getPostComments(postId: postId, completion: { response in
			switch response {
			case .success(let commentsResponse):
				comments = commentsResponse
			case .failure(let error):
				responseError = error
			}
			dispatchGroup.leave()
		}) {
			dataTasks.append(postCommentsTask)
		}
		
		dispatchGroup.notify(queue: .main, execute: {
			guard let user = user, let comments = comments else {
				completion(ResponseType.failure(responseError!))
				
				return
			}
			completion(ResponseType.success((user, comments)))
		})
		
		return dataTasks
	}
	
	private func getPostUser(userId: Int, completion: @escaping UserInfoCompletionBlock) -> URLSessionDataTask? {
		let userIdString = String(describing: userId)
		let params: [String: String] = ["id": userIdString]
		
		return networkingService.performRequest(route: Constants.Networking.USERS_ROUTE, queryParams: params, completion: { response in
			switch response {
			case .success(let payload):
				print(payload.description)
				let jsonDecoder = JSONDecoder()
				do {
					let user = try jsonDecoder.decode([User].self, from: payload.data).first!
					completion(ResponseType.success(user))
				} catch let error {
					print(error)
					completion(ResponseType.failure(APINetworkingError.jsonDecodingError))
				}
			case .failure(let error):
				print(error)
				completion(ResponseType.failure(error))
			}
		})
	}
	
	private func getPostComments(postId: Int, completion: @escaping PostCommentsCompletionBlock) -> URLSessionDataTask? {
		let postIdString = String(describing: postId)
		let params: [String: String] = ["postId": postIdString]
		
		return networkingService.performRequest(route: Constants.Networking.COMMENTS_ROUTE, queryParams: params, completion: { response in
			switch response {
			case .success(let payload):
				print(payload.description)
				let jsonDecoder = JSONDecoder()
				do {
					let comments = try jsonDecoder.decode([Comment].self, from: payload.data)
					completion(ResponseType.success(comments))
				} catch let error {
					print(error)
					completion(ResponseType.failure(APINetworkingError.jsonDecodingError))
				}
			case .failure(let error):
				print(error)
				completion(ResponseType.failure(error))
			}
		})
	}
}
