//
//  DatabaseService+Config.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

extension DatabaseService {
	func create<T: Collection>(configuration: DatabaseConfiguration = DatabaseConfiguration(), object: T, completion: (DatabaseCompletionHandler)? = nil) -> Void {}
	
	func read(configuration: DatabaseConfiguration = DatabaseConfiguration(), params: ParamsDict? = nil, completion: (DatabaseCompletionHandler)? = nil) -> Void {
		read(configuration: configuration, params: params, completion: completion)
	}
}
