//
//  DatabaseService+Config.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

extension DatabaseService {
	func create<T: Collection>(configuration: DatabaseConfiguration = DatabaseConfiguration(), object: T, completion: @escaping DatabaseCompletionHandler) -> Void {
		create(configuration: configuration, object: object, completion: completion)
	}
	
	func read(configuration: DatabaseConfiguration = DatabaseConfiguration(), params: ParamsDict? = nil, completion: @escaping DatabaseCompletionHandler) -> Void {
		read(configuration: configuration, params: params, completion: completion)
	}
}
