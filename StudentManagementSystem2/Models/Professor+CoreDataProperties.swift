//
//  Professors+CoreDataProperties.swift
//  StudentManagementSystem2
//
//  Created by Nabil Haffar on 10/7/19.
//  Copyright © 2019 Nabil Haffar. All rights reserved.
//
//
import UIKit
import Foundation
import CoreData


extension Professor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Professor> {
        return NSFetchRequest<Professor>(entityName: "Professor")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var officeAddress: String?
    @NSManaged public var homeAddress: String?
    @NSManaged public var email: String?
    @NSManaged public var photo: String?
    @NSManaged public var courses: NSSet?
    @NSManaged public var picture: NSData?
    @NSManaged public var streetAddress: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var zipCode: String?
}

// MARK: Generated accessors for courses
extension Professor {

    @objc(addCoursesObject:)
    @NSManaged public func addToCourses(_ value: Course)

    @objc(removeCoursesObject:)
    @NSManaged public func removeFromCourses(_ value: Course)

    @objc(addCourses:)
    @NSManaged public func addToCourses(_ values: NSSet)

    @objc(removeCourses:)
    @NSManaged public func removeFromCourses(_ values: NSSet)

}
