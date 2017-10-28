//
//  FireBaseDatabaseService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FirebaseDatabaseService: DatabaseService {
	func create<T: Collection>(configuration: DatabaseConfiguration, params: T, successCompletion: @escaping () -> Void, failureCompletion: @escaping (Error) -> Void) {
		let path = configuration.path
		var ref: DatabaseReference!
		ref = Database.database().reference()
		
		ref.child(path).setValue(params, withCompletionBlock: { error, databaseRef in
			if let e = error {
				failureCompletion(e)
			} else {
				successCompletion()
			}
		})
	}
	
	func read<T: Collection>(configuration: DatabaseConfiguration, params: T, successCompletion: @escaping ([String : Any]) -> Void, failureCompletion: @escaping (Error) -> Void) {
		
	}
}
