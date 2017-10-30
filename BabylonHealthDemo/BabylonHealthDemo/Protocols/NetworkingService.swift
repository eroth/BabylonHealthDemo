//
//  NetworkingService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

protocol NetworkingService {
	@discardableResult
	func performRequest(route: String, queryParams: [String : String]?, successCompletion: @escaping (Payload) -> Void, failureCompletion: @escaping (Error) -> Void) -> URLSessionDataTask?
}
