//
//  Comment.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/25/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct Comment: Codable {
	enum CodingKeys: String, CodingKey {
		case postId
		case commentId = "id"
		case name
		case email
		case body
	}
	
	let postId: Int
	let commentId: Int
	let name: String
	let email: String
	let body: String
}
