//
//  CoreDataManager.swift
//  DayList
//

import Foundation
import CoreData

class CoreDataManager {
    
    // Singleton instance
    static let shared = CoreDataManager()
    
    // Track currently logged-in user
    private(set) var currentUserId: String?
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DayList")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data Error: \(error), \(error.userInfo)")
            } else {
                print("Core Data loaded successfully")
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
                print("Context saved successfully")
            } catch {
                let nserror = error as NSError
                print("Save Error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Task CRUD Operations

extension CoreDataManager {
    
    // CREATE - Add a new task
    func createTask(
        title: String,
        dateText: String? = nil,
        subtaskCount: Int = 0,
        listName: String? = nil,
        tagColorHex: String? = nil
    ) -> TaskEntity {
        let task = TaskEntity(context: context)
        task.taskId = UUID().uuidString
        task.title = title
        task.dateText = dateText
        task.subtaskCount = Int16(subtaskCount)
        task.listName = listName
        task.tagColorHex = tagColorHex
        task.createdAt = Date()
        
        // Link task to current user
        if let userId = currentUserId {
            task.userId = userId
        } else {
            print("Warning: Creating task without userId")
        }
        
        saveContext()
        print("Task created: \(title)")
        return task
    }
    
    // READ - Fetch all tasks for CURRENT USER ONLY
    func fetchAllTasks() -> [TaskEntity] {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        // Filter by current user
        guard let userId = currentUserId else {
            print("Warning: No current user, returning empty tasks")
            return []
        }
        
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            print("Fetched \(tasks.count) tasks for user: \(userId)")
            return tasks
        } catch {
            print("Fetch Tasks Error: \(error)")
            return []
        }
    }

    
    // UPDATE - Modify an existing task
    func updateTask(
        _ task: TaskEntity,
        title: String? = nil,
        dateText: String? = nil,
        subtaskCount: Int? = nil,
        listName: String? = nil,
        tagColorHex: String? = nil
    ) {
        if let title = title { task.title = title }
        if let dateText = dateText { task.dateText = dateText }
        if let subtaskCount = subtaskCount { task.subtaskCount = Int16(subtaskCount) }
        if let listName = listName { task.listName = listName }
        if let tagColorHex = tagColorHex { task.tagColorHex = tagColorHex }
        
        saveContext()
        print("Task updated: \(task.title ?? "")")
    }
    
    // DELETE - Remove a task
    func deleteTask(_ task: TaskEntity) {
        let title = task.title ?? "Untitled"
        context.delete(task)
        saveContext()
        print("Task deleted: \(title)")
    }
    
    // DELETE ALL - Clear all tasks for CURRENT USER ONLY
    func deleteAllTasks() {
        let tasks = fetchAllTasks()
        tasks.forEach { context.delete($0) }
        saveContext()
        print("All tasks deleted for current user")
    }
}

// MARK: - User CRUD Operations

extension CoreDataManager {
    
    // Set current user after login/signup
    func setCurrentUser(userId: String) {
        self.currentUserId = userId
        print("Current user set: \(userId)")
    }
    
    // Clear current user on logout
    func clearCurrentUser() {
        self.currentUserId = nil
        print("Current user cleared")
    }
    
    // CREATE - Save user after signup
    func createUser(userId: String, name: String, email: String) -> UserEntity {
        let user = UserEntity(context: context)
        user.userId = userId
        user.name = name
        user.email = email
        user.createdAt = Date()
        
        saveContext()
        
        // Auto-set as current user
        setCurrentUser(userId: userId)
        
        print("User created: \(name) | Email: \(email)")
        return user
    }
    
    // READ - Get current user
    func getCurrentUser() -> UserEntity? {
        guard let userId = currentUserId else {
            print("No current user ID")
            return nil
        }
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.fetchLimit = 1
        
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Fetch User Error: \(error)")
            return nil
        }
    }
    
    // UPDATE - Update user info
    func updateUser(_ user: UserEntity, name: String? = nil) {
        if let name = name { user.name = name }
        saveContext()
        print("User updated: \(user.name ?? "")")
    }
    
    // DELETE - Remove user (for logout/account deletion)
    func deleteUser(_ user: UserEntity) {
        context.delete(user)
        saveContext()
        print("User deleted")
    }
    
    // CHECK - Does user exist?
    func userExists() -> Bool {
        return getCurrentUser() != nil
    }
}
