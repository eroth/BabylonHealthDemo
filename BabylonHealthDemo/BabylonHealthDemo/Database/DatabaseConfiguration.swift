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
	
	init(path: String = String()) {
		self.path = path
	}
}
