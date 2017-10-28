//
//  DataManager.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct DataManager {
	typealias T = Post
//	let networkingService: NetworkingService
//	let databaseService: DatabaseService
	
	init(networkingService: NetworkingService = VanillaNetworkingService(), databaseService: DatabaseService = FirebaseDatabaseService()) {
//		self.networkingService = networkingService
//		self.databaseService = databaseService
	}
}
