//
//  Post.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/24/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation

struct Post : Decodable {
	enum CodingKeys: String, CodingKey {
		case userId
		case postId = "id"
		case title
		case body
	}
	
	let userId: Int
	let postId: Int
	let title: String
	let body: String
}
