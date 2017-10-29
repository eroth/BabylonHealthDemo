//
//  Persistable.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

protocol DatabaseService {
	typealias ParamsDict = [String: Any]
	
	func create<T: Collection>(configuration: DatabaseConfiguration, object: T, successCompletion: @escaping () -> Void, failureCompletion: @escaping (Error) -> Void)
	
	func read(configuration: DatabaseConfiguration, params: ParamsDict?, successCompletion: @escaping (Any) -> Void, failureCompletion: @escaping (Error) -> Void)
}
