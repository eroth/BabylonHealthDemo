//
//  BabylonHealthAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

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
	func getPosts(successCompletion: @escaping ([Post]) -> Void, failureCompletion: @escaping (Error) -> Void) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.POSTS_ROUTE, queryParams: nil, successCompletion: { payload in
			print(payload.description)
			let jsonDecoder = JSONDecoder()
			do {
				let posts = try jsonDecoder.decode([Post].self, from: payload.data)
			} catch {
				failureCompletion(APIError.jsonDecodingError)
			}
		}, errorCompletion: { error in
			
		})
	}
}
