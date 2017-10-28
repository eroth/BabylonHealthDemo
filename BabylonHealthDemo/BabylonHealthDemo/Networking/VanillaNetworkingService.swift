//
//  NetworkingService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

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

enum CustomError: LocalizedError {
	case noDataReceived
	case urlError
	
	var errorDescription: String? {
		switch self {
		case .noDataReceived:
			return "No Data Returned From Server"
		case .urlError:
			return "There was an error creating the URL"
		}
	}
}

struct VanillaNetworkingService : NetworkingService {
	@discardableResult
	func performRequest(route: String, queryParams: [String : String]?, successCompletion: @escaping (Payload) -> Void, errorCompletion: @escaping (Error) -> Void) -> URLSessionDataTask? {
		guard let url = URLConfig(path: route, queryComponents: queryParams).url else {
			errorCompletion(CustomError.urlError)
			
			return nil
		}

		let request = URLRequest.defaultRequest(url: url)
		
		let dataTask = URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
			if let e = error {
				DispatchQueue.main.async {
					errorCompletion(e)
					
					return
				}
			}
			
			guard let payload = Payload(data: data) else {
				errorCompletion(CustomError.noDataReceived)
				
				return
			}
			
			successCompletion(payload)
		}
		
		dataTask.resume()
		
		return dataTask
	}
}
