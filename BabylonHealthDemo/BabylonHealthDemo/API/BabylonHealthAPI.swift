//
//  BabylonHealthAPI.swift
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

struct BabylonHealthAPI {
	private let networkingService: NetworkingService
	
	init(networkingService: NetworkingService = VanillaNetworking()) {
		self.networkingService = networkingService
	}
	
	@discardableResult
	func getPosts(successCompletion: @escaping PostsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.POSTS_ROUTE, queryParams: nil, successCompletion: { payload in
//			print(payload.description)
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
	func getPostDetails(userId: Int, postId: Int, successCompletion: @escaping PostDetailsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		getPostUser(userId: userId, successCompletion: { userInfo in
			
		}, failureCompletion: { error in
			
		})
		
		getPostComments(postId: postId, successCompletion: { comments in
			
		}, failureCompletion: { error in
			
		})
		
		return nil
	}
	
	private func getPostUser(userId: Int, successCompletion: @escaping UserInfoCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.USERS_ROUTE, queryParams: nil, successCompletion: { payload in
			print(payload.description)
			let jsonDecoder = JSONDecoder()
			do {
				let user = try jsonDecoder.decode([User].self, from: payload.data).first
				print("here")
			} catch let e {
				print(e)
			}
		}, errorCompletion: { error in
			print(error)
		})
	}
	
	private func getPostComments(postId: Int, successCompletion: @escaping PostCommentsCompletionBlock, failureCompletion: @escaping FailureCompletionBlock) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.COMMENTS_ROUTE, queryParams: nil, successCompletion: { payload in
			print(payload.description)
			let jsonDecoder = JSONDecoder()
			do {
				let comments = try jsonDecoder.decode([Comment].self, from: payload.data)
				print("here")
			} catch let e {
				print(e)
			}
		}, errorCompletion: { error in
			print(error)
		})
	}
}
