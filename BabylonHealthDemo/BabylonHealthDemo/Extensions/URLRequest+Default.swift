//
//  URLRequest+Default.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

extension URLRequest {
	enum HTTPMethod: String {
		case get = "GET"
	}
	
	static func defaultRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		request.timeoutInterval = Constants.Networking.REQUEST_TIMEOUT_INTERVAL
		request.httpMethod = HTTPMethod.get.rawValue
		
		return request
	}
}
