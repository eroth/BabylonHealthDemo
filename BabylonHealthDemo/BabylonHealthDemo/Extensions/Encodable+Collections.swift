//
//  Encodable+Collections.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/28/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import UIKit

extension Encodable {
	func asDictionary() throws -> [String: Any] {
		let data = try JSONEncoder().encode(self)
		guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
			throw NSError()
		}
		
		return dictionary
	}
}

extension Encodable {
	func asArray() throws -> [Any] {
		let data = try JSONEncoder().encode(self)
		guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
			throw NSError()
		}
		return array
	}
}
