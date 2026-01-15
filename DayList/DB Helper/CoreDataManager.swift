//
//  CoreDataManager.swift
//  DayList
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton instance
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DayList")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print(" Core Data Error: \(error), \(error.userInfo)")
            } else {
                print(" Core Data loaded successfully")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print(" Context saved successfully")
            } catch {
                let nserror = error as NSError
                print(" Save Error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
