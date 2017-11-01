//
//  DatabaseService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

protocol DatabaseService {
	typealias ParamsDict = [String: Any]
	typealias DatabaseCompletionHandler = (ResponseType<DatabaseResponse>) -> Void
	
	func create<T: Collection>(configuration: DatabaseConfiguration, object: T, completion: DatabaseCompletionHandler?) -> Void
	
	func read(configuration: DatabaseConfiguration, params: ParamsDict?, completion: DatabaseCompletionHandler?) -> Void
}
