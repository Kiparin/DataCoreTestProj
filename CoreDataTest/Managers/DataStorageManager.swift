//
//  DataStorage.swift
//  CoreDataTest
//
//  Created by Alexey Kiparin on 05.01.2025.
//

import Foundation
import CoreData

final class DataStorageManager {
	static let shared = DataStorageManager()
	
	private init(){}
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "CoreDataTest")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}

