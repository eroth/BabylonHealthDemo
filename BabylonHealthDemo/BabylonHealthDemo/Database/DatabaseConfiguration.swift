//
//  DatabaseConfig.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct DatabaseConfiguration {
	let path: String
	let childPath: String?
	
	init(path: String = String(), childPath: String? = nil) {
		self.path = path
		self.childPath = childPath
	}
}
