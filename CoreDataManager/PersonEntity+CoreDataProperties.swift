//
//  PersonEntity+CoreDataProperties.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-23.
//
//

import Foundation
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "PersonEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}

extension PersonEntity : Identifiable {

}
