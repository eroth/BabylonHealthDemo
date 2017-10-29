//
//  DatabaseService+Config.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

extension DatabaseService {
	func create(configuration: DatabaseConfiguration = DatabaseConfiguration()) {}
	
	func read(configuration: DatabaseConfiguration = DatabaseConfiguration(), params: ParamsDict? = nil, successCompletion: @escaping (Any) -> Void, failureCompletion: @escaping (Error) -> Void) {
		read(configuration: configuration, params: params, successCompletion: successCompletion, failureCompletion: failureCompletion)
	}
}
