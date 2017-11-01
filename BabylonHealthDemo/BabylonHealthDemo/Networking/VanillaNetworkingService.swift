//
//  VaniallaNetworkingService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import UIKit

enum ResponseType<T> {
	case success(T)
	case failure(Error)
}

struct Payload: CustomStringConvertible {
	let data: Data
	
	var description: String {
		return String(data: self.data, encoding:String.Encoding.utf8) ?? "Data could not be converted to a string"
	}
	
	init?(data: Data?) {
		guard let unwrappedData = data else {
			return nil
		}
		self.data = unwrappedData
	}
}

enum NetworkingServiceError: LocalizedError {
	case noDataReceived
	case urlError
	
	var errorDescription: String? {
		switch self {
		case .noDataReceived:
			return "No Data Returned From Server."
		case .urlError:
			return "There was an error creating the URL."
		}
	}
}

struct VanillaNetworkingService : NetworkingService {
	@discardableResult
	func performRequest(route: String, queryParams: [String : String]?, completion: @escaping NetworkingCompletionHandler) -> URLSessionDataTask? {
		guard let url = URLConfig(path: route, queryComponents: queryParams).url else {
			completion(ResponseType.failure(NetworkingServiceError.urlError))
			return nil
		}
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		let request = URLRequest.defaultRequest(url: url)
		let dataTask = URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				if let e = error {
					completion(ResponseType.failure(e))
					return
				}
				guard let payload = Payload(data: data) else {
					completion(ResponseType.failure(NetworkingServiceError.noDataReceived))
					return
				}
				completion(ResponseType.success(payload))
			}
		}
		dataTask.resume()
		
		return dataTask
	}
}
