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
	func create<T: Collection>(configuration: DatabaseConfiguration, object: T, successCompletion: @escaping () -> Void, failureCompletion: @escaping (Error) -> Void) {
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
				failureCompletion(e)
			} else {
				successCompletion()
			}
		})
	}
	
	func read(configuration: DatabaseConfiguration, params: DatabaseService.ParamsDict?, successCompletion: @escaping (Any) -> Void, failureCompletion: @escaping (Error) -> Void) {
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
					successCompletion(snapshot)
				} else {
					failureCompletion(APIDatabaseError.databaseReadError)
				}
			}
		})

		DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Database.FIREBASE_OPERATION_TIMEOUT, execute: {
			if !didTimeout && !didComplete {
				didTimeout = true
				failureCompletion(APIDatabaseError.databaseReadError)
			}
		})
	}
}
