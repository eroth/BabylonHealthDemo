//
//  NetworkingService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

typealias NetworkingCompletionHandler = (ResponseType<Payload>) -> Void

protocol NetworkingService {
	@discardableResult
	func performRequest(route: String, queryParams: [String : String]?, completion: @escaping NetworkingCompletionHandler) -> URLSessionDataTask?
}
