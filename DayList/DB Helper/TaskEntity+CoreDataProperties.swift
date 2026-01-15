//
//  TaskEntity+CoreDataProperties.swift
//  DayList
//
//  Created by iPHTech4 on 1/15/26.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var taskId: String?
    @NSManaged public var userId: String?
    @NSManaged public var title: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var dateText: String?
    @NSManaged public var subtaskCount: Int16
    @NSManaged public var listName: String?
    @NSManaged public var tagColorHex: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date?

}

extension TaskEntity : Identifiable {

}
