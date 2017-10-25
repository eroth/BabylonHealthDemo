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
		case phone
		case website
		case company
	}
	
	let userId: Int
	let name: String
	let username: String
	let email: String
	let address: UserAddress
	let phone: String
	let website: String
	let company: UserCompany
	
	struct UserAddress: Decodable {
		let street: String
		let suite: String
		let city: String
		let zipcode: String
		let geo: UserGeo
		
		struct UserGeo: Decodable {
			let lat: String
			let lng: String
		}
	}
	
	struct UserCompany: Decodable {
		enum CodingKeys: String, CodingKey {
			case name
			case catchPhrase
			case valueAdd = "bs"
		}
		
		let name: String
		let catchPhrase: String
		let valueAdd: String
	}
}
