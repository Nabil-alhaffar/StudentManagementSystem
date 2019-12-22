//
//  Courses+CoreDataProperties.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/7/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var departmentCode: String?
    @NSManaged public var number: Int16
    @NSManaged public var name: String?
    @NSManaged public var time: String?
    @NSManaged public var daysItMeets: String?
    @NSManaged public var students: NSSet?
    @NSManaged public var professors: NSSet?
    @NSManaged public var courseNumber: String?


}

// MARK: Generated accessors for students
extension Course {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

// MARK: Generated accessors for professors
extension Course {

    @objc(addProfessorsObject:)
    @NSManaged public func addToProfessors(_ value: Professor)

    @objc(removeProfessorsObject:)
    @NSManaged public func removeFromProfessors(_ value: Professor)

    @objc(addProfessors:)
    @NSManaged public func addToProfessors(_ values: NSSet)

    @objc(removeProfessors:)
    @NSManaged public func removeFromProfessors(_ values: NSSet)

}
