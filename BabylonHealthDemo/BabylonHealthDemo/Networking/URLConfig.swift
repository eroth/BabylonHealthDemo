//
//  URLConfig.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct URLConfig {
	enum HTTPScheme : String {
		case http
		case https
	}
	
	var host: String
	var scheme: String
	var path: String
	var queryComponents: [String : String]?
	
	init(scheme: HTTPScheme = .http, host: String = Constants.Networking.API_HOST, path: String, queryComponents: [String : String]?) {
		self.scheme = scheme.rawValue
		self.host = host
		self.path = path
		self.queryComponents = queryComponents
	}
	
	var url: URL? {
		var urlComponents = URLComponents()
		urlComponents.scheme = scheme
		urlComponents.host = host
		urlComponents.path = path
		
		if let components = queryComponents {
			urlComponents.queryItems = components.map { URLQueryItem(name: $0, value: $1) }
		}
		
		guard let url = urlComponents.url else { return nil }
		
		return url
	}
}
