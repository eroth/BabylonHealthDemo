//
//  BabylonHealthAPI.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct BabylonHealthAPI {
	private let networkingService: NetworkingService
	
	init(networkingService: NetworkingService = VanillaNetworking()) {
		self.networkingService = networkingService
	}
	
	@discardableResult
	func getPosts(successCompletion: @escaping ([Post]) -> Void, failureCompletion: @escaping (Error) -> Void) -> URLSessionDataTask? {
		return networkingService.performRequest(route: Constants.Networking.POSTS_ROUTE, queryParams: nil, successCompletion: { payload in
			print(payload.description)
		}, errorCompletion: { error in
			
		})
	}
}
