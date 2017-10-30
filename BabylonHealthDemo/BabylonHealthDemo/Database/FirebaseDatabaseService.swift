//
//  FireBaseDatabaseService.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/27/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DatabaseResponse {
	let data: Any
	let reference: Any?
	
	init(data: Any, reference: Any? = nil) {
		self.data = data
		self.reference = reference
	}
}

struct FirebaseDatabaseService: DatabaseService {
	func create<T: Collection>(configuration: DatabaseConfiguration, object: T, completion: (DatabaseCompletionHandler)? = nil) -> Void {
		let path = configuration.path
		var ref: DatabaseReference!
		ref = Database.database().reference()
		let parentNode = ref.child(path)
		var writeNode = parentNode
		
		if let childPath = configuration.childPath {
			let childNode = parentNode.child(childPath)
			writeNode = childNode
		}
		writeNode.setValue(object, withCompletionBlock: { error, databaseRef in
			if let e = error {
				completion?(ResponseType.failure(e))
				return
			}
			completion?(ResponseType.success(DatabaseResponse(data: databaseRef)))
		})
	}
	
	func read(configuration: DatabaseConfiguration, completion: (DatabaseCompletionHandler)? = nil) -> Void {
		let path = configuration.path
		var ref: DatabaseReference!
		ref = Database.database().reference()
		let parentNode = ref.child(path)
		var readNode = parentNode
		var didTimeout = false
		var didComplete = false
		
		if let childPath = configuration.childPath {
			let childNode = parentNode.child(childPath)
			readNode = childNode
		}

		readNode.observeSingleEvent(of: .value, with: { snapshot in
			didComplete = true
			if !didTimeout {
				if snapshot.exists() {
					guard let value = snapshot.value else {
						completion?(ResponseType.failure(APIDatabaseError.databaseReadError))
						return
					}
					completion?(ResponseType.success(DatabaseResponse(data: value)))
					return
				}
				completion?(ResponseType.failure(APIDatabaseError.databaseReadError))
			}
		})

		DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Database.FIREBASE_OPERATION_TIMEOUT, execute: {
			if !didTimeout && !didComplete {
				didTimeout = true
				completion?(ResponseType.failure(APIDatabaseError.databaseReadError))
			}
		})
	}
}
