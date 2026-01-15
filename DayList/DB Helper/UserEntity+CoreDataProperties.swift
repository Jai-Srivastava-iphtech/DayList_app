//
//  UserEntity+CoreDataProperties.swift
//  DayList
//
//  Created by iPHTech4 on 1/15/26.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var userId: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var createdAt: Date?

}

extension UserEntity : Identifiable {

}
