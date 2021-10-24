//
//  Factory.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-25.
//

import Foundation
import CoreData

class Factory {
    
    static func createDBHandler(withContext: NSManagedObjectContext) -> DBHandlerProtocol {
        let dbHandler = DBHandler(withContext: withContext)
        return dbHandler
    }
}
