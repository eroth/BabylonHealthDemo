//
//  Persistable.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

protocol DatabaseService {
	func readData(params: Any, successCompletion: @escaping ([String: Any]) -> Void, failureCompletion: @escaping (Error) -> Void)
}
