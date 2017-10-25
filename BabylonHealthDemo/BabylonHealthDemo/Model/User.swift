//
//  User.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/25/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct User: Decodable {
	enum CodingKeys: String, CodingKey {
		case userId = "id"
		case name
		case username
		case email
		case address
	}
	
	let userId: Int
	let name: String
	let username: String
	let email: String
	let address: String
	
	struct UserAddress: Decodable {
		let street: String
		let suite: String
		let city: String
		let zipcode: String
	}
}
